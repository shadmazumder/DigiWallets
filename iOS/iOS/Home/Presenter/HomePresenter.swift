//
//  HomePresenter.swift
//  iOS
//
//  Created by Shad Mazumder on 4/6/22.
//

import Foundation

public enum HomeViewControllerError: Error {
    case unsetURLs
}

public protocol HomeViewErrorDelegate{
    func handleErrorState(_ error: Error)
}

protocol HomeLoadingView {
    func display(_ viewModel: HomeLoadingViewModel)
}

protocol HomeView {
    func display(_ wallets: WalletViewModel)
    func display(_ transaction: TransactionViewModel)
}

public final class HomePresenter{
    private let homeView: HomeView
    private let loadingView: HomeLoadingView
    private let errorDelegate: HomeViewErrorDelegate
    
    let walletURL: URL?
    let transactionURL: URL?
    
    init(homeView: HomeView, loadingView: HomeLoadingView, errorDelegate: HomeViewErrorDelegate, walletURL: URL?, transactionURL: URL?) {
        self.homeView = homeView
        self.loadingView = loadingView
        self.errorDelegate = errorDelegate
        self.walletURL = walletURL
        self.transactionURL = transactionURL
    }
    
    func didStartLoading(){
        loadingView.display(HomeLoadingViewModel(isLoading: true))
    }
    
    func didFinishedLoading(with error: Error){
        stopLoading()
        errorDelegate.handleErrorState(error)
    }
    
    func didFinishedLoading(with wallets: [Wallet]){
        stopLoading()
        homeView.display(WalletViewModel(wallet: wallets))
    }
    
    func didFinishedLoading(with transactions: [Transaction]){
        stopLoading()
        homeView.display(TransactionViewModel(transaction: transactions))
    }
    
    private func stopLoading(){
        loadingView.display(HomeLoadingViewModel(isLoading: false))
    }
}
