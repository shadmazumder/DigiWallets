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
    func test_getFromURL_performsGETRequestWithURL() {
             let anyURL = anyURL
             let sut = URLSessionHTTPClient()
             let exp = expectation(description: "Waiting for response")

             URLProtocolStub.startInterceptingRequest()

             URLProtocolStub.observeRequest { request in
                 XCTAssertEqual(request.url, anyURL)
                 XCTAssertEqual(request.httpMethod, "GET")
                 exp.fulfill()
             }

             sut.get(from: anyURL){ _ in }

             wait(for: [exp], timeout: 0.5)

             URLProtocolStub.stopInterceptingRequest()
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
