//
//  RemoteLoaderTests.swift
//  CryptoLoaderTests
//
//  Created by Shad Mazumder on 27/5/22.
//

import XCTest

enum HTTPResult {
    enum Error {
        case connectivity
        case non200HTTPResponse
    }
    
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

protocol HTTPClient{
    func get(from url: URL, completion: @escaping ((HTTPResult) -> Void))
}

class RemoteLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(from url: URL, completion: @escaping ((HTTPResult) -> Void)){
        client.get(from: url) { result in
                     switch result {
                     case let .success(data, response):
                         if response.statusCode == 200{
                             completion(.success(data, response))
                         }else{
                             completion(.failure(.non200HTTPResponse))
                         }
                     default:
                         completion(.failure(.connectivity))
                     }
        }
    }
}

class RemoteLoaderTests: XCTestCase {
    func test_init_doesNotCallAPI() {
        let (_ , spy) = makeSUT()
        
        XCTAssertTrue(spy.message.isEmpty)
    }
    
    func test_loadFromURL_callsOnURL() {
        let (remoteLoader, spy) = makeSUT()
        
        remoteLoader.load(from: anyURL) {_ in}
        
        XCTAssertEqual(spy.message.first?.url, anyURL)
    }
    
    func test_multipleLoadRequest_resultsInMultipleURLCall() {
        let anotherUrl = URL(string: "any-other-url")!
        let (remoteLoader, spy) = makeSUT()
        
        remoteLoader.load(from: anyURL) {_ in}
        remoteLoader.load(from: anotherUrl) {_ in}
        
        XCTAssertEqual(spy.message.map({$0.url}), [anyURL, anotherUrl])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, tocompleteWith: .failure(.connectivity), with: anyURL) {
            client.completeWithError(.connectivity)
        }
    }
    
    func test_load_deliversNon200ResponseErrorOnNon200HTTPResponseStatusCode() {
        let (sut, client) = makeSUT()
        let non200HTTPResponseStatusCode = [199, 201, 233, 401]
        let non200HTTPResponses = non200HTTPResponseStatusCode.map({HTTPURLResponse(url: anyURL, statusCode: $0, httpVersion: nil, headerFields: nil)})
        
        
        non200HTTPResponses.enumerated().forEach({ index, response in
            expect(sut, tocompleteWith: .failure(HTTPResult.Error.non200HTTPResponse), with: anyURL) {
                client.completeWith(Data(), response: response!, index: index)
            } })
    }
    
    func test_load_deliversDataOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        let jsonWithData = anyValidJsonStringWithData()
        
        expect(sut, tocompleteWith: .success(jsonWithData.data, anyHTTP200URLResponse), with: anyURL) {
            client.completeWith(jsonWithData.data, response: anyHTTP200URLResponse)
        }
    }
    
    // MARK: - Hepler
    private func makeSUT() -> (remoteLoader: RemoteLoader, spy: ClientSpy){
        let spy = ClientSpy()
        let remoteLoader = RemoteLoader(client: spy)
        
        return (remoteLoader, spy)
    }
    
    private func expect(_ sut: RemoteLoader, tocompleteWith expectedResult: HTTPResult, with url: URL, when action: ()-> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for the client")
        
        sut.load(from: url) { result in
            switch (result, expectedResult) {
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            case let (.success(receivedData, receivedResponse), .success(expectedData, expectedResponse)):
                XCTAssertEqual(receivedData, expectedData)
                
                XCTAssertEqual(receivedResponse.url, expectedResponse.url)
                XCTAssertEqual(receivedResponse.statusCode, expectedResponse.statusCode)
            default:
                XCTFail("Expected \(expectedResult) but got \(result)", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}

class ClientSpy: HTTPClient {
    typealias Result = (url: URL, completion: ((HTTPResult) -> Void))
    var message = [Result]()
    
    init() {}
    
    func get(from url: URL, completion: @escaping ((HTTPResult) -> Void)) {
        message.append((url, completion))
    }
    
    func completeWith(_ data: Data, response: HTTPURLResponse, index: Int = 0) {
        message[index].completion(.success(data, response))
    }
    
    func completeWithError(_ error: HTTPResult.Error, index: Int = 0) {
        message[index].completion(.failure(error))
    }
}
