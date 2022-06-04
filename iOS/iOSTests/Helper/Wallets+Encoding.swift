//
//  Wallets+Encoding.swift
//  iOSTests
//
//  Created by Shad Mazumder on 2/6/22.
//

import Foundation
import APILayer

extension WalletAPIModel: Encodable{
    enum CodingKeys: String, CodingKey {
        case id
        case walletName
        case balance
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(walletName, forKey: .walletName)
        try container.encode(balance, forKey: .balance)
    }
}

extension Wallets: Encodable{
    enum CodingKeys: String, CodingKey {
        case wallets
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(wallets, forKey: .wallets)
    }
}
