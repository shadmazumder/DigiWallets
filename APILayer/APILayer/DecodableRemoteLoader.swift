//
//  DecodableRemoteLoader.swift
//  APILayer
//
//  Created by Shad Mazumder on 29/5/22.
//

import Foundation
import CryptoLoader

public final class DecodableRemoteLoader: DecodableLoader{
    private let client: HTTPClient
    
    public init(_ client: HTTPClient) {
        self.client = client
    }
    
    public func load<T>(from url: URL, of type: T.Type, completion: @escaping ((DecodableResult) -> Void)) where T : Decodable {
        client.get(from: url) { [weak self] result in
            switch result{
            case let .success(responseData, _):
                self?.decode(from: responseData, of: T.self, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
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
