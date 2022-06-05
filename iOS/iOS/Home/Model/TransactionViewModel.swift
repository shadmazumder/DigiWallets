//
//  Transaction.swift
//  iOS
//
//  Created by Shad Mazumder on 3/6/22.
//

import Foundation
import APILayer

struct TransactionViewModel {
    let transaction: [Transaction]
}

public struct Transaction{
    public let id: String
    public let description: String
    public let sender: String
    public let amount: String
    
    public init(id: String, description: String, sender: String, amount: String){
        self.id = id
        self.description = description
        self.sender = sender
        self.amount = amount
    }
}

extension Transaction: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Transaction{
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

extension Transaction{
    init(transaction: TransactionAPIModel) {
        id = transaction.id
        description = Transaction.description(from: transaction)
        sender = transaction.sender
        amount = Transaction.amount(from: transaction)
    }
}

extension TransactionAPIModel{
    var transactionViewModel: Transaction{Transaction(transaction: self)}
}

extension Array where Element == TransactionAPIModel{
    var mapToTransactionViewModel: [Transaction]{ map({$0.transactionViewModel}) }
}

