//
//  UITableView+DequeCell.swift
//  iOS
//
//  Created by Shad Mazumder on 3/6/22.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
