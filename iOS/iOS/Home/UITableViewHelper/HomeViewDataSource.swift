//
//  HomeViewDataSource.swift
//  iOS
//
//  Created by Shad Mazumder on 3/6/22.
//

import UIKit

public class HomeViewDataSource:UITableViewDiffableDataSource<HomeViewSection, AnyHashable>{
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        HomeViewSection.allCases[section].rawValue
    }
}
