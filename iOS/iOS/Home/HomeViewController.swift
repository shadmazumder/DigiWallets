//
//  HomeViewController.swift
//  iOS
//
//  Created by Shad Mazumder on 30/5/22.
//

import UIKit

public enum HomeViewControllerError: Error {
    case unsetURLs
}

public protocol HomeViewControllerDelegate{
    func handleErrorState(_ error: Error)
}

public class HomeViewController: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    public var delegate: HomeViewControllerDelegate?
    
    public private(set) lazy var dataSource: UITableViewDiffableDataSource<Int, HomeViewModel> = {
        .init(tableView: homeTableView) { (_, _, _) in
            UITableViewCell()
        }
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.handleErrorState(HomeViewControllerError.unsetURLs)
    }
}
