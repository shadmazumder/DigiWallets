//
//  Histories.swift
//  APILayer
//
//  Created by Shad Mazumder on 29/5/22.
//

import Foundation

public struct Histories: Decodable {
    public let histories: [Transaction]
    
    public init(histories: [Transaction]) {
        self.histories = histories
    }
}
