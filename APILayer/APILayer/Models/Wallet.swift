//
//  Wallet.swift
//  APILayer
//
//  Created by Shad Mazumder on 29/5/22.
//

import Foundation

public struct Wallet: Decodable {
    public let id: String
    public let walletName: String
    public let balance: String
    
    public init(id: String, walletName: String, balance: String) {
        self.id = id
        self.walletName = walletName
        self.balance = balance
    }
}
