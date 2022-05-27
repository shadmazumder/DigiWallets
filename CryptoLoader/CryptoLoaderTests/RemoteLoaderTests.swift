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

protocol HTTPClient{}

class RemoteLoader {
    init(client: HTTPClient) {}
}

class RemoteLoaderTests: XCTestCase {
    func test_init_doesNotCallAPI() {
        let spy = ClientSpy()
        let _ = RemoteLoader(client: spy)
        XCTAssertTrue(spy.message?.isEmpty ?? false)
    }
}

class ClientSpy: HTTPClient {
    var message: [HTTPClientResponse]?
    
    init() {
        message = [HTTPClientResponse]()
    }
}
