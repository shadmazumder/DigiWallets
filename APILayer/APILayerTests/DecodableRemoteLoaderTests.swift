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
        let (decodedError, data) = anyDecodableErrorWithData
        
        expect(loader, toCompleteWith: .failure(decodedError)) {
            client.completeWith(data)
        }
    }
    
    func test_load_deliversDecodedObjectOnProperData() {
        let (loader, client) = makeSUT()
        let validJson = anyValidJsonStringWithData
        
        expect(loader, toCompleteWith: .success(validJson.validJsonString)) {
            client.completeWith(validJson.data)
        }
    }
    
    // MARK: - Helper
    typealias StringRemoteLoader = DecodableRemoteLoader<String>
    
    private func makeSUT() -> (remoteLoader: StringRemoteLoader, client: StubClient) {
        let client = StubClient()
        let decodableLoader = DecodableRemoteLoader<String>(client)
        return (decodableLoader, client)
    }
    
    private func expect(_ sut: StringRemoteLoader, toCompleteWith expectedResult: StringRemoteLoader.Result, when action: (()-> Void), file: StaticString = #file, line: UInt = #line){
        let exp = expectation(description: "Wait for Decodable Remote Loader")
        
        sut.load(from: anyURL) { result in
            switch (result, expectedResult){
            case let (.success(received), .success(expected)):
                XCTAssertEqual(received, expected)
            case let (.failure(received), .failure(expected)):
                XCTAssertEqual(received.localizedDescription, expected.localizedDescription)
            default:
                XCTFail("Expected \(expectedResult), but got \(result)")
            }
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 0.4)
    }
    
    private var anyURL: URL {URL(string: "any-url")!}
    private var anyDecodableErrorWithData: (error: Error, data: Data){
        let data = Data()
        let decoder = JSONDecoder()
        do {
            let _ = try decoder.decode(String.self, from: data)
            return (NSError(domain: "", code: -1), data)
        } catch {
            return (error, data)
        }
        
    }
    private var anyValidJsonStringWithData: (validJsonString: String, data: Data) {
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
