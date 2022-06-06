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
    // MARK: - Remote Load
    func test_init_doesNotCallAPI() {
        let (_ , spy) = makeSUT()
        
        XCTAssertTrue(spy.message.isEmpty)
    }
    
    func test_loadFromURL_callsOnURL() {
        let (remoteLoader, spy) = makeSUT()
        
        remoteLoader.load(from: anyURL, of: String.self) {_ in}
        
        XCTAssertEqual(spy.message.first?.url, anyURL)
    }
    
    func test_multipleLoadRequest_resultsInMultipleURLCall() {
        let anotherUrl = URL(string: "any-other-url")!
        let (remoteLoader, spy) = makeSUT()
        
        remoteLoader.load(from: anyURL, of: String.self) {_ in}
        remoteLoader.load(from: anotherUrl, of: String.self) {_ in}
        
        XCTAssertEqual(spy.message.map({$0.url}), [anyURL, anotherUrl])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemoteLoader.ResultError.connectivity), of: String.self) {
            client.completeWithError(RemoteLoader.ResultError.connectivity)
        }
    }
    
    func test_load_deliversNon200ResponseErrorOnNon200HTTPResponseStatusCode() {
        let (sut, client) = makeSUT()
        let non200HTTPResponseStatusCode = [199, 201, 233, 401]
        let non200HTTPResponses = non200HTTPResponseStatusCode.map({HTTPURLResponse(url: anyURL, statusCode: $0, httpVersion: nil, headerFields: nil)})
        
        
        non200HTTPResponses.enumerated().forEach({ index, response in
            expect(sut, toCompleteWith: .failure(DecodableRemoteLoader.ResultError.non200HTTPResponse), of: String.self) {
                client.completeWith(Data(), response: response!, index: index)
            } })
    }
    
    func test_load_doesNotDeliverResultAfterSUTBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: DecodableRemoteLoader? = DecodableRemoteLoader(client)
        var receivedResult: DecodableResult?
        sut?.load(from: anyURL, of: String.self, completion: { receivedResult = $0 })
        
        sut = nil
        let anyHTTP200URLResponse = HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        client.completeWith(anyValidJsonStringWithData.data, response: anyHTTP200URLResponse)
        
        XCTAssertNil(receivedResult)
    }
    
    // MARK: - Decoding
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
        let client = HTTPClientSpy()
        var sut: DecodableRemoteLoader? = DecodableRemoteLoader(client)
        var receivedResult: DecodableResult?
        sut?.load(from: anyURL, of: String.self, completion: { receivedResult = $0 })
        
        sut = nil
        client.completeWith(anyValidJsonStringWithData.data)
        
        XCTAssertNil(receivedResult)
    }
    
    // MARK: - Helper
    private func makeSUT() -> (remoteLoader: DecodableRemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let decodableLoader = DecodableRemoteLoader(client)
        trackMemoryLeak(decodableLoader)
        trackMemoryLeak(client)
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
