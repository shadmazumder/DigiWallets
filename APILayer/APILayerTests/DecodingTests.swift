//
//  DecodingTests.swift
//  APILayerTests
//
//  Created by Shad Mazumder on 29/5/22.
//

import XCTest
import APILayer

struct Wallet: Decodable {
    let id: String
    let walletName: String
    let balance: String
}

class DecodingTests: XCTestCase {
    func test_load_deliversCamelCaseFromSnakeFormat() {
        let wallet = Wallet(id: "anyID", walletName: "anyName", balance: "anyBalance")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let encodedData = try! encoder.encode(wallet)
        
        let client = StubClient()
        let loader = DecodableRemoteLoader<Wallet>(client)
        expect(loader, toCompleteWith: .success(wallet)) {
            client.completeWith(encodedData)
        }
    }
}

extension Wallet: Equatable, Encodable{}
