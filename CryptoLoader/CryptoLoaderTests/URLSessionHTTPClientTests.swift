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
        session.dataTask(with: url){ _, response, _ in
            if let response = response as? HTTPURLResponse{
                completion(.success(Data(), response))
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
    
    // MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient{
        let sut = URLSessionHTTPClient()
        return sut
    }
}


class URLProtocolStub: URLProtocol {
    private static var requestObservable: ((URLRequest) -> Void)?
    
    static func observeRequest(observer: @escaping ((URLRequest)-> Void)){
        requestObservable = observer
    }
    
    static func startInterceptingRequest(){
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopInterceptingRequest(){
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        URLProtocolStub.requestObservable?(request)
    }
}
