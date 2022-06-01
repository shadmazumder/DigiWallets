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

public class HomeViewController: UIViewController {
    @IBOutlet weak public private(set) var homeTableView: UITableView!
    
    public var delegate: HomeViewControllerDelegate?
    public var loader: DecodableRemoteLoader?
    public var walletsURL: URL?
    public var transactionsURL: URL?
    
    public private(set) lazy var dataSource: UITableViewDiffableDataSource<Int, HomeViewModel> = {
        .init(tableView: homeTableView) { (_, _, _) in
            UITableViewCell()
        }
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        loadFromRemote()
    }
    
    private func loadFromRemote(){
        guard let walletsURL = walletsURL,  let transactions = transactionsURL else{
            delegate?.handleErrorState(HomeViewControllerError.unsetURLs)
            return
        }
        
        loader?.load(from: walletsURL, of: [Wallet].self, completion: { [weak self] result in
            switch result {
            case .success(_):
                break
            case let .failure(error):
                self?.delegate?.handleErrorState(error)
            }
        })
        
        loader?.load(from: transactions, of: [Transaction].self, completion: { [weak self] result in
            switch result {
            case .success(_):
                break
            case let .failure(error):
                self?.delegate?.handleErrorState(error)
            }
        })
    }
}
