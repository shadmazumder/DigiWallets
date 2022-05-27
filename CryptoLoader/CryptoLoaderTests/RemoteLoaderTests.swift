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
        let spy = ClientSpy()
        
        let _ = RemoteLoader(client: spy)
        
        XCTAssertTrue(spy.message.isEmpty)
    }
    
    func test_loadFromURL_callsOnURL() {
        let spy = ClientSpy()
        let remoteLoader = RemoteLoader(client: spy)
        
        remoteLoader.load(from: anyURL)
        
        XCTAssertEqual(spy.message.first?.key, anyURL)
    }
    
    // MARK: - Hepler
    private let anyURL = URL(string: "any-url")!
}

class ClientSpy: HTTPClient {
    var message = [URL: HTTPClientResponse]()
    
    init() {}
    
    func get(from url: URL) {
        message[url] = .success
    }
}
