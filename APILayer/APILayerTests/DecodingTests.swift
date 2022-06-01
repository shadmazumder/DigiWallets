//
//  DecodingTests.swift
//  APILayerTests
//
//  Created by Shad Mazumder on 29/5/22.
//

import XCTest
import APILayer

class DecodingTests: XCTestCase {
    func test_load_deliversCamelCaseFromSnakeFormat() {
        let walletMapper = WalletMapper(id: "anyID", walletName: "anyName", balance: "anyBalance")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let encodedData = try! encoder.encode(walletMapper)

        let client = StubClient()
        let loader = DecodableRemoteLoader(client)
        expect(loader, toCompleteWith: .success(walletMapper.toWallet), of: Wallet.self) {
            client.completeWith(encodedData)
        }
    }
}

extension Wallet: Equatable{
    public static func == (lhs: Wallet, rhs: Wallet) -> Bool { lhs.id == rhs.id }
}

struct WalletMapper: Equatable, Encodable{
    let id: String
    let walletName: String
    let balance: String
}

extension WalletMapper{
    var toWallet: Wallet{ Wallet(id: id, walletName: walletName, balance: balance)}
}
