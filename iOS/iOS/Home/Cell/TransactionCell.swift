//
//  TransactionCell.swift
//  iOS
//
//  Created by Shad Mazumder on 3/6/22.
//

import UIKit

public class TransactionCell: UITableViewCell {
    @IBOutlet public private(set) weak var details: UILabel!
    @IBOutlet public private(set) weak var amount: UILabel!
    
    func configure(_ viewModel: TransactionViewModel){
        details.text = viewModel.description
        amount.text = viewModel.amount
    }
}
