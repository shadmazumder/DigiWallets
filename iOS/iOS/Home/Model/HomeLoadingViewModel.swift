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
}