//
//  HomeViewController+TestHelper.swift
//  iOSTests
//
//  Created by Shad Mazumder on 1/6/22.
//

import UIKit
import iOS

extension HomeViewController{
    func section(for section: HomeViewSection) -> Int{
        switch section {
        case .wallets:
            return 0
        case .transaction:
            return 1
        }
    }
    
    private func indexPath(_ index: Int) -> IndexPath{
        IndexPath(row: index, section: 0)
    }
    
    func cell(_ index: Int = 0) -> UITableViewCell?{
        tableView.cellForRow(at: indexPath(index))
    }
    
    func walletCell(_ index: Int = 0) -> WalletCell?{
        tableView.cellForRow(at: IndexPath(row: index, section: section(for: .wallets))) as? WalletCell
    }
    
    var numberOfWalletsCell: Int{
        tableView.numberOfRows(inSection: section(for: .wallets))
    }
    
    var numberOfTransactionsCell: Int{
        tableView.numberOfRows(inSection: section(for: .transaction))
    }
    
    func transactionsCell(_ index: Int = 0) -> TransactionCell?{
        tableView.cellForRow(at: IndexPath(row: index, section: section(for: .transaction))) as? TransactionCell
    }
    
    func simulatePullToRefresh(){
        refreshControl?.allTargets.forEach({ target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach({
                (target as NSObject).perform(Selector($0))
            })
        })
    }
    
    func simulateWalletCellSelection(){
        tableView.deselectRow(at: IndexPath(row: 0, section: section(for: .wallets)), animated: false)
    }
    
    func simulateTransactionCellSelection(){
        tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: 0, section: section(for: .transaction)))
    }
}
