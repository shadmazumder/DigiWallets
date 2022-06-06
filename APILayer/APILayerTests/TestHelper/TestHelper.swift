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

    func expect<T: Decodable & Equatable>(_ sut: DecodableRemoteLoader, toCompleteWith expectedResult: DecodableResult, of type:  T.Type, when action: (()-> Void), file: StaticString = #file, line: UInt = #line){
        let exp = expectation(description: "Wait for Decodable Remote Loader")
        
        sut.load(from: anyURL, of: T.self) { result in
            switch (result, expectedResult){
            case let (.success(received), .success(expected)):
                XCTAssertEqual((received as? T), (expected as? T))
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
    
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Memory Leak!!! Didn't deallocated", file: file, line: line)
        }
    }
}
