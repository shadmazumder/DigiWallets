//
//  ClientSpy.swift
//  iOSTests
//
//  Created by Shad Mazumder on 5/6/22.
//

import Foundation
import CryptoLoader

class ClientSpy: HTTPClient {
    typealias Result = (url: URL, completion: ((HTTPResult) -> Void))
    var message = [Result]()
    
    init() {}
    
    func get(from url: URL, completion: @escaping ((HTTPResult) -> Void)) {
        message.append((url, completion))
    }
    
    func completeWithSuccess(_ data: Data, index: Int = 0) {
        let response = HTTPURLResponse(url: URL(string: "any-url")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        message[index].completion(.success(data, response))
    }
    
    func completeWithError(_ error: RemoteLoader.ResultError, index: Int = 0) {
        message[index].completion(.failure(error))
    }
}
