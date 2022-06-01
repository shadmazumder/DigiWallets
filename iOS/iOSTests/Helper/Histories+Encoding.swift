//
//  Histories+Encoding.swift
//  iOSTests
//
//  Created by Shad Mazumder on 2/6/22.
//

import Foundation
import APILayer

extension Transaction: Encodable{
    enum CodingKeys: String, CodingKey {
        case id
        case entry
        case amount
        case currency
        case sender
        case recipient
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(entry, forKey: .entry)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(sender, forKey: .sender)
        try container.encode(recipient, forKey: .recipient)
    }
}

extension Histories: Encodable{
    enum CodingKeys: String, CodingKey {
        case histories
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(histories, forKey: .histories)
    }
}
