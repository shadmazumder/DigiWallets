//
//  DecodableRemoteLoaderTests.swift
//  APILayerTests
//
//  Created by Shad Mazumder on 28/5/22.
//

import XCTest
import CryptoLoader
import APILayer

class DecodableRemoteLoaderTests: XCTestCase {
    func test_load_deliversErrorOnFaultyData() {
        let (loader, client) = makeSUT()
        let (decodedError, data) = anyDecodableErrorWithData
        
        expect(loader, toCompleteWith: .failure(decodedError), of: String.self) {
            client.completeWith(data)
        }
    }
    
    func test_load_deliversDecodedObjectOnProperData() {
        let (loader, client) = makeSUT()
        let validJson = anyValidJsonStringWithData
        
        expect(loader, toCompleteWith: .success(validJson.validJsonString), of: String.self) {
            client.completeWith(validJson.data)
        }
    }
    
    func test_load_doesnotDeliversResultOnceSUTBeenDeallocated() {
        let client = StubClient()
        var sut: DecodableRemoteLoader? = DecodableRemoteLoader(client)
        var receivedResult: DecodableResult?
        sut?.load(from: anyURL, of: String.self, completion: { receivedResult = $0 })
        
        sut = nil
        client.completeWith(anyValidJsonStringWithData.data)
        
        XCTAssertNil(receivedResult)
    }
    
    // MARK: - Helper
    private func makeSUT() -> (remoteLoader: DecodableRemoteLoader, client: StubClient) {
        let client = StubClient()
        let decodableLoader = DecodableRemoteLoader(client)
        return (decodableLoader, client)
    }
    
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
