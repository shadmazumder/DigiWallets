//
//  TransactionViewModel.swift
//  iOS
//
//  Created by Shad Mazumder on 3/6/22.
//

import Foundation
import APILayer

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

