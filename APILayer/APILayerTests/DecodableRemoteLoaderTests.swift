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
        let client = ClientSpy()
        var sut: DecodableRemoteLoader? = DecodableRemoteLoader(client)
        var receivedResult: DecodableResult?
        sut?.load(from: anyURL, of: String.self, completion: { receivedResult = $0 })
        
        sut = nil
        client.completeWith(anyValidJsonStringWithData.data)
        
        XCTAssertNil(receivedResult)
    }
    
    // MARK: - Helper
    private func makeSUT() -> (remoteLoader: DecodableRemoteLoader, client: ClientSpy) {
        let client = ClientSpy()
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

class ClientSpy: HTTPClient {
    typealias Result = (url: URL, completion: ((HTTPResult) -> Void))
    var message = [Result]()
    
    init() {}
    
    func get(from url: URL, completion: @escaping ((HTTPResult) -> Void)) {
        message.append((url, completion))
    }
    
    func completeWithError(_ error: RemoteLoader.ResultError, index: Int = 0) {
        message[index].completion(.failure(error))
    }
    
    func completeWith(_ data: Data, index: Int = 0) {
        let http200Response = HTTPURLResponse(url: message[index].url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        completeWith(data, response: http200Response, index: index)
    }
    
    func completeWith(_ data: Data, response: HTTPURLResponse, index: Int = 0) {
        message[index].completion(.success(data, response))
    }
}
