//
//  DecodableRemoteLoader.swift
//  APILayer
//
//  Created by Shad Mazumder on 29/5/22.
//

import Foundation
import CryptoLoader

public final class DecodableRemoteLoader<T: Decodable> {
    public enum Result {
        case success(T)
        case failure(Error)
    }
    
    private let client: HTTPClient
    
    public init(_ client: HTTPClient) {
        self.client = client
    }
    
    public func load(from url: URL, completion: @escaping ((Result) -> Void)){
        client.get(from: url) { [weak self] result in
            switch result{
            case let .success(responseData, _):
                self?.decode(from: responseData, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func decode(from responseData: Data, completion: @escaping ((Result) -> Void)) {
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
