//
//  Wallets.swift
//  APILayer
//
//  Created by Shad Mazumder on 29/5/22.
//

import Foundation

public struct Wallets: Decodable{
    public let wallets: [Wallet]
    
    public init(wallets: [Wallet]){
        self.wallets = wallets
    }
}
