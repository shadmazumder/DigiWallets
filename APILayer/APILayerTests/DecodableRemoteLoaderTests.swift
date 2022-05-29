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
        client.get(from: url) { result in
            switch result{
            case let .success(responseData, _):
                self.decode(from: responseData, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func decode(from responseData: Data, completion: @escaping ((Result) -> Void)) {
        do{
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(T.self, from: responseData)
            completion(.success(decoded))
        }
        catch {
            completion(.failure(error))
        }
    }
}

class DecodableRemoteLoaderTests: XCTestCase {
    func test_load_deliversErrorOnFaultyData() {
        let (loader, client) = makeSUT()
        let exp = expectation(description: "Wait for Decodable Remote Loader")
        loader.load(from: anyURL){ result in
            if case let .failure(error) = result, let _ = error as? DecodingError {
                exp.fulfill()
            }
        }
        
        client.completeWith(anyNonDecodableData)
        
        wait(for: [exp], timeout: 0.4)
    }
    
    func test_load_deliversDecodedObjectOnProperData() {
        let validJson = anyValidJsonStringWithData
        let (loader, client) = makeSUT()
        let exp = expectation(description: "Wait for Decodable Remote Loader")
        loader.load(from: anyURL){ result in
            if case let .success(model) = result, model == validJson.validJsonString{
                exp.fulfill()
            }
        }
        
        client.completeWith(validJson.data)
        
        wait(for: [exp], timeout: 0.4)
    }
    
    // MARK: - Helper
    typealias StringRemoteLoader = DecodableRemoteLoader<String>
    
    private func makeSUT() -> (remoteLoader: StringRemoteLoader, client: StubClient) {
        let client = StubClient()
        let decodableLoader = DecodableRemoteLoader<String>(client)
        return (decodableLoader, client)
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
