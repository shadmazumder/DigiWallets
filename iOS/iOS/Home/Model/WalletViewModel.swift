//
//  WalletViewModel.swift
//  iOS
//
//  Created by Shad Mazumder on 3/6/22.
//

import Foundation
import APILayer

public struct WalletViewModel{
    public let id: String
    public let name: String
    public let amount: String
}

extension WalletViewModel: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Wallet{
    var walletViewModel: WalletViewModel{ WalletViewModel(id: id, name: walletName, amount: balance) }
}

extension Array where Element == Wallet{
    var mapToWalletViewModel: [WalletViewModel] { map({$0.walletViewModel}) }
}
