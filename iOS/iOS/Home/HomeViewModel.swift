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

public struct TransactionViewModel{
    public let id: String
    public let description: String
    public let currency: String
}

extension TransactionViewModel: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TransactionViewModel{
    init(transaction: Transaction) {
        id = transaction.id
        description = ""
        currency = transaction.currency
    }
}

extension Transaction{
    var transactionViewModel: TransactionViewModel{TransactionViewModel(transaction: self)}
}

extension Array where Element == Transaction{
    var mapToTransactionViewModel: [TransactionViewModel]{ map({$0.transactionViewModel}) }
}
