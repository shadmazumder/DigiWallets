//
//  HomeLoaderPresentationAdapter.swift
//  iOS
//
//  Created by Shad Mazumder on 4/6/22.
//

import Foundation
import APILayer

final class HomeLoaderPresentationAdapter: HomeViewControllerDelegate{
    private let remoteLoader: DecodableLoader?
    var presenter: HomePresenter?
    
    init(remoteLoader: DecodableLoader) {
        self.remoteLoader = remoteLoader
    }
    
    func didRequestHomeRefresh() {
        presenter?.didStartLoading()
        
        guard let walletsURL = presenter?.walletURL,  let transactionsURL = presenter?.transactionURL else{
            presenter?.didFinishedLoading(with: HomeViewControllerError.unsetURLs)
            return
        }
        loadWallets(from: walletsURL)
        loadTransactions(from: transactionsURL)
    }
    
    private func loadWallets(from url: URL){
        remoteLoader?.load(from: url, of: Wallets.self, completion: { [weak self] result in
            switch result {
            case let .success(walletAPIModel):
                let wallets = (walletAPIModel as! Wallets).wallets
                let walletViewModels = wallets.mapToWalletViewModel
                self?.presenter?.didFinishedLoading(with: walletViewModels)
            case let .failure(error):
                self?.presenter?.didFinishedLoading(with: error)
            }
        })
    }
    
    private func loadTransactions(from url: URL){
        remoteLoader?.load(from: url, of: Histories.self, completion: { [weak self] result in
            switch result {
            case let .success(historiesAPIModel):
                let transactions = (historiesAPIModel as! Histories).histories
                let transactionViewModels = transactions.mapToTransactionViewModel
                self?.presenter?.didFinishedLoading(with: transactionViewModels)
            case let .failure(error):
                self?.presenter?.didFinishedLoading(with: error)
            }
        })
    }
}
