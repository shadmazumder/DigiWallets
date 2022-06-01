//
//  Transaction.swift
//  APILayer
//
//  Created by Shad Mazumder on 29/5/22.
//

import Foundation

public struct Transaction: Decodable {
    public let id: String
    public let entry: String
    public let amount: String
    public let currency: String
    public let sender: String
    public let recipient: String
}
