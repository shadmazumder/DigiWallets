//
//  DecodableRemoteLoaderTests.swift
//  APILayerTests
//
//  Created by Shad Mazumder on 28/5/22.
//

import XCTest
import CryptoLoader

class DecodableRemoteLoader<T: Decodable> {
    enum Result {
        case success(T)
        case failure(Error)
    }
    private let client: HTTPClient
    
    init(_ client: HTTPClient) {
        self.client = client
    }
    
    func load(from url: URL, completion: @escaping ((Result) -> Void)){
        client.get(from: url) { _ in
            let decodingError = DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
            completion(.failure(decodingError))
        }
    }
}

class DecodableRemoteLoaderTests: XCTestCase {
    func test_load_deliversErrorOnFaultyData() {
        let exp = expectation(description: "Wait for Decodable Remote Loader")
        let client = StubClient()
        let decodableLoader = DecodableRemoteLoader<String>(client)
        decodableLoader.load(from: anyURL){ result in
            if case let .failure(error) = result, let _ = error as? DecodingError {
                exp.fulfill()
            }
        }
        
        client.completeWith(anyNonDecodableData)
        
        wait(for: [exp], timeout: 0.4)
    }
    
    var anyURL: URL {URL(string: "any-url")!}
    var anyNonDecodableData: Data {Data()}
    var anyValidJsonStringWithData: (validJsonString: String, data: Data) {
        let validJsonString = "{\"id\":\"some-id\"}"
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(validJsonString)
        
        return (validJsonString, data)
    }
}

class StubClient: HTTPClient {
    typealias Result = (url: URL, completion: ((HTTPResult) -> Void))
    var message = [Result]()
    
    init() {}
    
    func get(from url: URL, completion: @escaping ((HTTPResult) -> Void)) {
        message.append((url, completion))
    }
    
    func completeWith(_ data: Data, index: Int = 0) {
        let response = HTTPURLResponse(url: message[index].url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        message[index].completion(.success(data, response))
    }
}
