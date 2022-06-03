//
//  HomeViewController+TestHelper.swift
//  iOSTests
//
//  Created by Shad Mazumder on 1/6/22.
//

import UIKit
import iOS

extension HomeViewController{
    private func indexPath(_ index: Int) -> IndexPath{
        IndexPath(row: index, section: 0)
    }
    
    func cell(_ index: Int = 0) -> UITableViewCell{
        dataSource.tableView(tableView, cellForRowAt: indexPath(index))
    }
    
    var numberOfWalletsCell: Int{
        dataSource.snapshot().numberOfItems(inSection: .wallets)
    }
    
    func simulatePullToRefresh(){
        refreshControl?.allTargets.forEach({ target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach({
                (target as NSObject).perform(Selector($0))
            })
        })
    }
}
