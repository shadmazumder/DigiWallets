//
//  Wallet.swift
//  iOS
//
//  Created by Shad Mazumder on 3/6/22.
//

import Foundation
import APILayer

struct WalletViewModel {
    let wallet: [Wallet]
}

public struct Wallet{
    public let id: String
    public let name: String
    public let amount: String
}

extension Wallet: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension WalletAPIModel{
    var walletViewModel: Wallet{ Wallet(id: id, name: walletName, amount: balance) }
}

extension Array where Element == WalletAPIModel{
    var mapToWalletViewModel: [Wallet] { map({$0.walletViewModel}) }
}
