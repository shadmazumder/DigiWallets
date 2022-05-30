//
//  HomeViewController.swift
//  iOS
//
//  Created by Shad Mazumder on 30/5/22.
//

import UIKit

public class HomeViewController: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    
    public private(set) lazy var dataSource: UITableViewDiffableDataSource<Int, HomeViewModel> = {
        .init(tableView: homeTableView) { (_, _, _) in
            UITableViewCell()
        }
    }()
}
