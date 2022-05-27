//
//  TestHelper.swift
//  CryptoLoaderTests
//
//  Created by Shad Mazumder on 27/5/22.
//

import XCTest

extension XCTestCase{
    var anyURL: URL { URL(string: "any-url")!}
    
    var anyHTTP200URLResponse: HTTPURLResponse {HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!}
    
    func anyValidJsonStringWithData() -> (validJsonString: String, data: Data) {
        let validJsonString = "{\"id\":\"some-id\"}"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try! encoder.encode(validJsonString)
        
        return (validJsonString, data)
    }
}
