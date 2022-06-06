//
//  DecodableRemoteLoader.swift
//  APILayer
//
//  Created by Shad Mazumder on 29/5/22.
//

import Foundation
import CryptoLoader

public final class DecodableRemoteLoader: DecodableLoader{
    public enum ResultError: Error {
        case connectivity
        case non200HTTPResponse
        case unexpectedError
    }
    
    private let client: HTTPClient
    
    public init(_ client: HTTPClient) {
        self.client = client
    }
    
    public func load<T>(from url: URL, of type: T.Type, completion: @escaping ((DecodableResult) -> Void)) where T : Decodable {
        client.get(from: url) { [weak self] result in
            self?.mapResult(result, of:  T.self, into: completion)
        }
    }
    
    private func mapResult<T: Decodable>(_ result: HTTPResult, of type:  T.Type, into completion: @escaping ((DecodableResult) -> Void)){
        switch result {
        case let .success(data, response):
            mapHTTPResult(with: data, of: T.self, for: response, completion: completion)
        case let .failure(error):
            completion(.failure(error))
        }
    }
    
    private func mapHTTPResult<T: Decodable>(with data: Data, of type:  T.Type, for response: HTTPURLResponse, completion: @escaping ((DecodableResult) -> Void)){
        if response.statusCode == 200{
            decode(from: data, of: T.self, completion: completion)
        }else{
            return completion(.failure(ResultError.non200HTTPResponse))
        }
    }
    
    private func decode<T: Decodable>(from responseData: Data, of type:  T.Type, completion: @escaping ((DecodableResult) -> Void)) {
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(T.self, from: responseData)
            completion(.success(decoded))
        }
        catch {
            completion(.failure(error))
        }
    }
}
