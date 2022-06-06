//
//  HTTPClientSpy.swift
//  APILayerTests
//
//  Created by Shad Mazumder on 6/6/22.
//

import Foundation
import CryptoLoader

class HTTPClientSpy: HTTPClient {
    typealias Result = (url: URL, completion: ((HTTPResult) -> Void))
    var message = [Result]()
    
    init() {}
    
    func get(from url: URL, completion: @escaping ((HTTPResult) -> Void)) {
        message.append((url, completion))
    }
    
    func completeWithError(_ error: ResultError, index: Int = 0) {
        message[index].completion(.failure(error))
    }
    
    func completeWith(_ data: Data, index: Int = 0) {
        let http200Response = HTTPURLResponse(url: message[index].url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        completeWith(data, response: http200Response, index: index)
    }
    
    func completeWith(_ data: Data, response: HTTPURLResponse, index: Int = 0) {
        message[index].completion(.success(data, response))
    }
}
