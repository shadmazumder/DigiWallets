//
//  HomeViewController.swift
//  iOS
//
//  Created by Shad Mazumder on 30/5/22.
//

import UIKit
import APILayer

public class HomeViewController: UITableViewController {
    var delegate: HomeViewControllerDelegate?
    public private(set) var dataSource: HomeViewDataSource!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControll()
        configureTableView()
        addSections()
        loadFromRemote()
    }
    
    private func addRefreshControll(){
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadFromRemote), for: .valueChanged)
    }
    
    private func configureTableView(){
        dataSource = HomeViewDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            self?.configuredCell(with: itemIdentifier, for: indexPath)
        })
    }
    
    private func addSections(){
        var snapShot = NSDiffableDataSourceSnapshot<HomeViewSection, AnyHashable>()
        snapShot.appendSections(HomeViewSection.allCases)
        dataSource.applySnapshotUsingReloadData(snapShot)
    }
    
    private func configuredCell(with model: AnyHashable, for index: IndexPath)->UITableViewCell{
        switch index.section{
        case 0:
            let walletCell: WalletCell = tableView.dequeueReusableCell()
            walletCell.configure(model as! Wallet)
            return walletCell
        case 1:
            let transactionCell: TransactionCell = tableView.dequeueReusableCell()
            transactionCell.configure(model as! Transaction)
            return transactionCell
        default:
            return UITableViewCell()
        }
    }
    
    @objc private func loadFromRemote(){
        delegate?.didRequestHomeRefresh()
    }
}
