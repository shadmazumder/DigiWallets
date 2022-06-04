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
    public let amount: String
}

extension TransactionViewModel: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TransactionViewModel{
    public static func description(from transaction: TransactionAPIModel) -> String{
        let action = action(for: transaction)
        let recipient = recipient(for: transaction)
        
        return "You've \(action) \(recipient)"
    }
    
    private static func action(for transaction: TransactionAPIModel)-> String{
        switch transaction.entry {
        case "incoming":
            return "received payment"
        case "outgoing":
            return "cashed out to"
        default:
            return "a transaction of"
        }
    }
    
    private static func recipient(for transaction: TransactionAPIModel)-> String{
        transaction.entry == "outgoing" ? transaction.recipient : ""
    }
    
    public static func amount(from transaction: TransactionAPIModel) -> String{
        let sign = transaction.entry == "outgoing" ? "-" : ""
        return "\(sign)\(transaction.amount) \(transaction.currency)"
    }
}

extension TransactionViewModel{
    init(transaction: TransactionAPIModel) {
        id = transaction.id
        description = TransactionViewModel.description(from: transaction)
        amount = TransactionViewModel.amount(from: transaction)
    }
}

extension TransactionAPIModel{
    var transactionViewModel: TransactionViewModel{TransactionViewModel(transaction: self)}
}

extension Array where Element == TransactionAPIModel{
    var mapToTransactionViewModel: [TransactionViewModel]{ map({$0.transactionViewModel}) }
}

