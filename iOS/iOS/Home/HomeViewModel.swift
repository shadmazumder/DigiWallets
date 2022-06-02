//
//  HomeViewModel.swift
//  iOS
//
//  Created by Shad Mazumder on 30/5/22.
//

import Foundation
import APILayer

public enum HomeViewSection: String, CaseIterable{
    case wallets = "My Wallets"
    case transaction = "Transactions"
}

public struct WalletViewModel: Hashable{}
extension Wallets{
    var walletsViewModel: [WalletViewModel]{[]}
}

public struct TransactionViewModel: Hashable{}
extension Histories{
    var transactionsViewModel: [TransactionViewModel]{[]}
}

