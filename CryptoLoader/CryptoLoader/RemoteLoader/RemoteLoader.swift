//
//  RemoteLoader.swift
//  CryptoLoader
//
//  Created by Shad Mazumder on 27/5/22.
//

import Foundation

public final class RemoteLoader {
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func load(from url: URL, completion: @escaping ((HTTPResult) -> Void)){
        client.get(from: url) { [weak self] result in
            self?.mapResult(result, into: completion)
        }
    }
    
    private func mapResult(_ result: HTTPResult, into completion: @escaping ((HTTPResult) -> Void)){
        switch result {
        case let .success(data, response):
            completion(mapHTTPResult(with: data, for: response))
        default:
            completion(.failure(.connectivity))
        }
    }
    
    private func mapHTTPResult(with data: Data, for response: HTTPURLResponse) -> HTTPResult{
        if response.statusCode == 200{
            return .success(data, response)
        }else{
            return .failure(.non200HTTPResponse)
        }
    }
    
}
