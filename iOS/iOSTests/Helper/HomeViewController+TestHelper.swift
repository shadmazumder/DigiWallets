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
        dataSource.tableView(homeTableView, cellForRowAt: indexPath(index))
    }
}
