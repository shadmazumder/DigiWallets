//
//  RemoteLoaderTests.swift
//  CryptoLoaderTests
//
//  Created by Shad Mazumder on 27/5/22.
//

import XCTest

enum HTTPClientResponse {
    case success
    case failure
}

protocol HTTPClient{
    func get(from url: URL, completion: @escaping ((HTTPClientResponse) -> Void))
}

class RemoteLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(from url: URL, completion: @escaping ((HTTPClientResponse) -> Void)){
        client.get(from: url) { _ in }
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
    
    // MARK: - Hepler
    private let anyURL = URL(string: "any-url")!
    
    private func makeSUT() -> (remoteLoader: RemoteLoader, spy: ClientSpy){
        let spy = ClientSpy()
        let remoteLoader = RemoteLoader(client: spy)
        
        return (remoteLoader, spy)
    }
}

class ClientSpy: HTTPClient {
    typealias Result = (url: URL, completion: ((HTTPClientResponse) -> Void))
    var message = [Result]()
    
    init() {}
    
    func get(from url: URL, completion: @escaping ((HTTPClientResponse) -> Void)) {
        message.append((url, completion))
    }
}
