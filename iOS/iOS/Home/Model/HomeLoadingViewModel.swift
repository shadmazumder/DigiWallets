//
//  HomeViewSection.swift
//  iOS
//
//  Created by Shad Mazumder on 3/6/22.
//

import Foundation

struct HomeLoadingViewModel {
    let isLoading: Bool
}

public enum HomeViewSection: String, CaseIterable{
    case wallets = "My Wallets"
    case transaction = "Transactions"
    
    public var section: Int{
        switch self {
        case .wallets:
            return 0
        case .transaction:
            return 1
        }
    }
}
