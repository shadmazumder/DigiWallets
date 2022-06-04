//
//  TransactionAPIModel.swift
//  APILayer
//
//  Created by Shad Mazumder on 29/5/22.
//

import Foundation

public struct TransactionAPIModel: Decodable {
    public let id: String
    public let entry: String
    public let amount: String
    public let currency: String
    public let sender: String
    public let recipient: String
    
    public init(id: String, entry: String, amount: String, currency: String, sender: String, recipient: String) {
        self.id = id
        self.entry = entry
        self.amount = amount
        self.currency = currency
        self.sender = sender
        self.recipient = recipient
    }
}
