//
//  HomeViewController+Loading.swift
//  iOS
//
//  Created by Shad Mazumder on 2/6/22.
//

import UIKit
import APILayer

public enum HomeViewControllerError: Error {
    case unsetURLs
}

public protocol HomeViewControllerDelegate{
    func handleErrorState(_ error: Error)
}

extension HomeViewController{
    @objc func loadFromRemote(){
        guard let walletsURL = walletsURL,  let transactionsURL = transactionsURL else{
            delegate?.handleErrorState(HomeViewControllerError.unsetURLs)
            return
        }

        refreshControl?.beginRefreshing()
        loadWallets(from: walletsURL)
        loadTransactions(from: transactionsURL)
    }
    
    private func loadWallets(from url: URL){
        loader?.load(from: url, of: Wallets.self, completion: { [weak self] result in
            self?.refreshControl?.endRefreshing()
            
            switch result {
            case let .success(walletsAPIModel):
                let wallets = walletsAPIModel as! Wallets
                self?.diffarableReload(wallets.wallets.mapToWalletViewModel, to: .wallets)
            case let .failure(error):
                self?.delegate?.handleErrorState(error)
            }
        })
    }
    
    private func diffarableReload(_ homeViewModel: [AnyHashable], to section: HomeViewSection){
        DispatchQueue.main.async { [weak self] in
            guard var snapShot = self?.dataSource.snapshot() else {return}
            
            snapShot.appendItems(homeViewModel, toSection: section)
            self?.dataSource.applySnapshotUsingReloadData(snapShot)
        }
    }
    
    private func loadTransactions(from url: URL){
        loader?.load(from: url, of: Histories.self, completion: { [weak self] result in
            self?.refreshControl?.endRefreshing()
            
            switch result {
            case let .success(historiesAPIModel):
                let histories = historiesAPIModel as! Histories
                self?.diffarableReload(histories.histories.mapToTransactionViewModel, to: .transaction)
            case let .failure(error):
                self?.delegate?.handleErrorState(error)
            }
        })
    }
}
