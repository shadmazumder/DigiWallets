//
//  HomeViewController.swift
//  iOS
//
//  Created by Shad Mazumder on 30/5/22.
//

import UIKit
import APILayer
import CryptoLoader

public enum HomeViewControllerError: Error {
    case unsetURLs
}

public protocol HomeViewControllerDelegate{
    func handleErrorState(_ error: Error)
}

public class HomeViewController: UITableViewController {
    public var delegate: HomeViewControllerDelegate?
    public var loader: DecodableRemoteLoader?
    public var walletsURL: URL?
    public var transactionsURL: URL?
    
    public private(set) lazy var dataSource: UITableViewDiffableDataSource<HomeViewSection, AnyHashable> = {
        .init(tableView: tableView) { (_, _, _) in
            UITableViewCell()
        }
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControll()
        addSections()
        loadFromRemote()
    }
    
    private func addRefreshControll(){
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadFromRemote), for: .valueChanged)
    }
    
    private func addSections(){
        var snapShot = NSDiffableDataSourceSnapshot<HomeViewSection, AnyHashable>()
        snapShot.appendSections(HomeViewSection.allCases)
    }
    
    @objc private func loadFromRemote(){
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
                self?.diffarableReload(wallets.walletsViewModel, to: .wallets)
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
                self?.diffarableReload(histories.transactionsViewModel, to: .transaction)
            case let .failure(error):
                self?.delegate?.handleErrorState(error)
            }
        })
    }
}
