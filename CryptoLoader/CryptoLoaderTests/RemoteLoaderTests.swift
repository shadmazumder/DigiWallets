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
    func get(from url: URL)
}

class RemoteLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(from url: URL){
        client.get(from: url)
    }
}

class RemoteLoaderTests: XCTestCase {
    func test_init_doesNotCallAPI() {
        let (_ , spy) = makeSUT()
        
        XCTAssertTrue(spy.message.isEmpty)
    }
    
    func test_loadFromURL_callsOnURL() {
        let (remoteLoader, spy) = makeSUT()
        
        remoteLoader.load(from: anyURL)
        
        XCTAssertEqual(spy.message.first?.key, anyURL)
    }
    
    func test_multipleLoadRequest_resultsInMultipleURLCall() {
        let anotherUrl = URL(string: "any-other-url")!
        let (remoteLoader, spy) = makeSUT()
        
        remoteLoader.load(from: anyURL)
        remoteLoader.load(from: anotherUrl)
        
        XCTAssertEqual(spy.message.map({$0.key}), [anyURL, anotherUrl])
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
    var message = [URL: HTTPClientResponse]()
    
    init() {}
    
    func get(from url: URL) {
        message[url] = .success
    }
}
