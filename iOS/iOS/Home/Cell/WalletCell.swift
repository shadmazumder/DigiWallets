//
//  WalletCell.swift
//  iOS
//
//  Created by Shad Mazumder on 2/6/22.
//

import UIKit

class WalletCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    func configure(_ viewModel: WalletViewModel){
        name.text = viewModel.name
        amount.text = viewModel.amount
    }
}
