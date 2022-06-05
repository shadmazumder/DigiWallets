//
//  URLSessionHTTPClientTests.swift
//  CryptoLoaderTests
//
//  Created by Shad Mazumder on 27/5/22.
//

import XCTest
import CryptoLoader

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
    
    func test_getFromURL_deliversConnectivityErrorOnNilDataWithNilResponse() {
        XCTAssertEqual(requestErrorFor(data: nil, response: nil, expectedError: anyNSError())?.localizedDescription, RemoteLoader.ResultError.connectivity.localizedDescription)
    }
    
    func test_getFromURL_failsOnAllInvalidValueRepresentatio() {
        XCTAssertNotNil(requestErrorFor(data: nil, response: nil, expectedError: nil))
        XCTAssertNotNil(requestErrorFor(data: nil, response: nonHTTPURLResponse, expectedError: nil))
        XCTAssertNotNil(requestErrorFor(data: anyData(), response: nil, expectedError: nil))
        XCTAssertNotNil(requestErrorFor(data: anyData(), response: anyHTTPURLResponse, expectedError: anyNSError()))
        XCTAssertNotNil(requestErrorFor(data: nil, response: nonHTTPURLResponse, expectedError: anyNSError()))
        XCTAssertNotNil(requestErrorFor(data: nil, response: anyHTTPURLResponse, expectedError: anyNSError()))
        XCTAssertNotNil(requestErrorFor(data: anyData(), response: nonHTTPURLResponse, expectedError: anyNSError()))
        XCTAssertNotNil(requestErrorFor(data: anyData(), response: anyHTTPURLResponse, expectedError: anyNSError()))
        XCTAssertNotNil(requestErrorFor(data: anyData(), response: nonHTTPURLResponse, expectedError: nil))
    }
    
    func test_getFromURL_suceedsOnHTTPURLResponseWithData() {
        let expectedData = anyData()
        let expectedHTTPResponse = anyHTTPURLResponse
        let receivedValues = requestValuesFor(data: expectedData, response: expectedHTTPResponse, expectedError: nil)
        
        URLProtocolStub.stub(data: expectedData, response: expectedHTTPResponse, error: nil)
        
        XCTAssertEqual(receivedValues?.data, expectedData)
        XCTAssertEqual(receivedValues?.response.url, expectedHTTPResponse.url)
        XCTAssertEqual(receivedValues?.response.statusCode, expectedHTTPResponse.statusCode)
        
    }
    
    // MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient{
        let sut = URLSessionHTTPClient()
        return sut
    }
    
    private func requestValuesFor(data: Data?, response: URLResponse?, expectedError: Error?, file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)?{
        let result  = requestResultFor(data: data, response: response, expectedError: expectedError, file: file, line: line)
        
        switch result {
        case let .success(receivedData, receivedResponse):
            return (receivedData, receivedResponse)
        default:
            XCTFail("Was expecting Success but got \(result)", file: file, line: line)
            return nil
        }
    }
    
    private func requestErrorFor(data: Data?, response: URLResponse?, expectedError: Error?, file: StaticString = #file, line: UInt = #line) -> Error?{
        let result  = requestResultFor(data: data, response: response, expectedError: expectedError, file: file, line: line)
        
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Was expecting failure but got \(result)", file: file, line: line)
            return nil
        }
    }
    
    private func requestResultFor(data: Data?, response: URLResponse?, expectedError: Error?, file: StaticString = #file, line: UInt = #line) -> HTTPResult{
        let exp = expectation(description: "Waiting for completion")
        let sut = makeSUT(file: file, line: line)
        URLProtocolStub.stub(data: data, response: response, error: expectedError)
        
        
        var receivedResults: HTTPResult!
        
        sut.get(from: anyURL) { result in
            receivedResults = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        return receivedResults
    }
    
    private let anyData = {Data("any data".utf8)}
    private var nonHTTPURLResponse: URLResponse {URLResponse(url: anyURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)}
    private var anyHTTPURLResponse: HTTPURLResponse {HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!}
    private let anyNSError = {NSError(domain: "any domain", code: 0, userInfo: nil)}
}

private class URLProtocolStub: URLProtocol {
    private struct Stub{
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    private static var stub: Stub?
    private static var requestObservable: ((URLRequest) -> Void)?
    
    static func stub(data: Data?, response: URLResponse?, error: Error?){
        stub = Stub(data: data, response: response, error: error)
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
        if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let response = URLProtocolStub.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
