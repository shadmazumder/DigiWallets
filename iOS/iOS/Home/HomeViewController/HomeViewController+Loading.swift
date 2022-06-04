//
//  HomeViewController+Loading.swift
//  iOS
//
//  Created by Shad Mazumder on 2/6/22.
//

import UIKit

extension HomeViewController: HomeView{
    func display(_ wallets: WalletViewModel) {
        diffarableReload(wallets.wallet, to: .wallets)
    }
    
    func display(_ transaction: TransactionViewModel) {
        diffarableReload(transaction.transaction, to: .transaction)
    }
    
    private func diffarableReload(_ homeViewModel: [AnyHashable], to section: HomeViewSection){
        var snapShot = dataSource.snapshot()
        snapShot.appendItems(homeViewModel, toSection: section)
        dataSource.applySnapshotUsingReloadData(snapShot)
    }
}

extension HomeViewController: HomeLoadingView{
    func display(_ viewModel: HomeLoadingViewModel) {
        viewModel.isLoading ? refreshControl?.beginRefreshing() : refreshControl?.endRefreshing()
    }
}
