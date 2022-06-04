//
//  Wallets.swift
//  APILayer
//
//  Created by Shad Mazumder on 29/5/22.
//

import Foundation

public struct Wallets: Decodable{
    public let wallets: [WalletAPIModel]
    
    public init(wallets: [WalletAPIModel]){
        self.wallets = wallets
    }
}
