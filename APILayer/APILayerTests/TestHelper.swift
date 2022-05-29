//
//  TestHelper.swift
//  APILayerTests
//
//  Created by Shad Mazumder on 29/5/22.
//

import XCTest
import APILayer

extension XCTestCase{
    var anyURL: URL {URL(string: "any-url")!}

    func expect<T: Equatable>(_ sut: DecodableRemoteLoader<T>, toCompleteWith expectedResult: DecodableRemoteLoader<T>.Result, when action: (()-> Void), file: StaticString = #file, line: UInt = #line){
        let exp = expectation(description: "Wait for Decodable Remote Loader")
        
        sut.load(from: anyURL) { result in
            switch (result, expectedResult){
            case let (.success(received), .success(expected)):
                XCTAssertEqual(received, expected)
            case let (.failure(received), .failure(expected)):
                XCTAssertEqual(received.localizedDescription, expected.localizedDescription)
            default:
                XCTFail("Expected \(expectedResult), but got \(result)")
            }
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 0.4)
    }
}
