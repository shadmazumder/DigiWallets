//
//  URLSessionHTTPClient.swift
//  CryptoLoader
//
//  Created by Shad Mazumder on 27/5/22.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping (HTTPResult) -> Void) {
        session.dataTask(with: url){ [weak self] data, response, error in
            if let error = error {
                self?.mapError(error, response: response, data: data, completion: completion)
            }else if let data = data, let response = response as? HTTPURLResponse{
                completion(.success(data, response))
            }else{
                completion(.failure(RemoteLoader.ResultError.unexpectedError))
            }
        }.resume()
    }
    
    private func mapError(_ error: Error, response: URLResponse?, data: Data?,completion: @escaping ((HTTPResult) -> Void)){
        if let _ = response, let _ = data{
            completion(.failure(error))
        }
        completion(.failure(RemoteLoader.ResultError.connectivity))
    }
}
