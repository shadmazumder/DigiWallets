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
    
    case success(HTTPURLResponse)
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
                     case .success:
                         completion(.failure(.non200HTTPResponse))
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
        
        non200HTTPResponseStatusCode.enumerated().forEach({ index, statusCode in
            expect(sut, tocompleteWith: .failure(HTTPResult.Error.non200HTTPResponse), with: anyURL) {
                client.completeWith(statusCode: statusCode, index: index)
            } })
    }
    
    // MARK: - Hepler
    private let anyURL = URL(string: "any-url")!
    
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
    
    func completeWith(statusCode: Int = 200, index: Int = 0) {
        let response = HTTPURLResponse(url: message[index].url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        
        message[index].completion(.success(response))
    }
    
    func completeWithError(_ error: HTTPResult.Error, index: Int = 0) {
        message[index].completion(.failure(error))
    }
}
