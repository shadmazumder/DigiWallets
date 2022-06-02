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
    
    public private(set) lazy var dataSource: UITableViewDiffableDataSource<Int, HomeViewModel> = {
        .init(tableView: tableView) { (_, _, _) in
            UITableViewCell()
        }
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        loadFromRemote()
    }
    
    private func loadFromRemote(){
        guard let walletsURL = walletsURL,  let transactionsURL = transactionsURL else{
            delegate?.handleErrorState(HomeViewControllerError.unsetURLs)
            return
        }
        loadWallets(from: walletsURL)
        loadTransactions(from: transactionsURL)
    }
    
    private func loadWallets(from url: URL){
        loader?.load(from: url, of: Wallets.self, completion: { [weak self] result in
            switch result {
            case .success(_):
                break
            case let .failure(error):
                self?.delegate?.handleErrorState(error)
            }
        })
    }
    
    private func loadTransactions(from url: URL){
        loader?.load(from: url, of: Histories.self, completion: { [weak self] result in
            switch result {
            case .success(_):
                break
            case let .failure(error):
                self?.delegate?.handleErrorState(error)
            }
        })
    }
}
