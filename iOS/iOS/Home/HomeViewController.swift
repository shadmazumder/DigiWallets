//
//  HomeViewController.swift
//  iOS
//
//  Created by Shad Mazumder on 30/5/22.
//

import UIKit
import APILayer

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
}
