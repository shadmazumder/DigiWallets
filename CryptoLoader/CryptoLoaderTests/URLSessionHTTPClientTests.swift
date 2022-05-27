//
//  URLSessionHTTPClientTests.swift
//  CryptoLoaderTests
//
//  Created by Shad Mazumder on 27/5/22.
//

import XCTest

class URLSessionHTTPClientTests: XCTestCase {
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
