//
//  URLSessionHTTPClientTests.swift
//  CryptoLoaderTests
//
//  Created by Shad Mazumder on 27/5/22.
//

import XCTest
import CryptoLoader

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPResult) -> Void) {
        session.dataTask(with: url){ _, response, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequest()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequest()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let anyURL = anyURL
        let exp = expectation(description: "Waiting for response")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, anyURL)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: anyURL){ _ in }
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let givenError = NSError(domain: "Session error", code: 1)
        
        let receivedError = requestErrorFor(expectedError: givenError) as NSError?
        
        XCTAssertEqual(receivedError?.domain, givenError.domain)
        XCTAssertEqual(receivedError?.code, givenError.code)
    }
    
    // MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient{
        let sut = URLSessionHTTPClient()
        return sut
    }
    
    private func requestErrorFor(expectedError: Error?, file: StaticString = #file, line: UInt = #line) -> Error?{
        let result  = requestResultFor(expectedError: expectedError, file: file, line: line)
        
        switch result {
        case let .failure(error):
            return error
        default:
            if let result = result {
                XCTFail("Was expecting failure but got \(result)", file: file, line: line)
            }else{
                XCTFail("Was expecting failure but got success with nil result 👻", file: file, line: line)
            }
            return nil
        }
    }
    
    private func requestResultFor(expectedError: Error?, file: StaticString = #file, line: UInt = #line) -> HTTPResult?{
        let exp = expectation(description: "Waiting for completion")
        let sut = makeSUT(file: file, line: line)
        
        URLProtocolStub.stub(error: expectedError)
        
        var receivedResults: HTTPResult?
        
        sut.get(from: anyURL) { result in
            receivedResults = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        return receivedResults
    }
}


private class URLProtocolStub: URLProtocol {
    private struct Stub{
        let error: Error?
    }
    
    private static var stub: Stub?
    private static var requestObservable: ((URLRequest) -> Void)?
    
    static func stub(error: Error?){
        stub = Stub(error: error)
    }
    
    static func observeRequest(observer: @escaping ((URLRequest)-> Void)){
        requestObservable = observer
    }
    
    static func startInterceptingRequest(){
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopInterceptingRequest(){
        URLProtocol.unregisterClass(URLProtocolStub.self)
        stub = nil
        URLProtocolStub.requestObservable = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let requestObserver = URLProtocolStub.requestObservable{
            client?.urlProtocolDidFinishLoading(self)
            return requestObserver(request)
        }
        
        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}}
