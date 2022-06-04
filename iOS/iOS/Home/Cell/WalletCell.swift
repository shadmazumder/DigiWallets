//
//  WalletCell.swift
//  iOS
//
//  Created by Shad Mazumder on 2/6/22.
//

import UIKit

public class WalletCell: UITableViewCell {
    @IBOutlet public private(set) weak var name: UILabel!
    @IBOutlet public private(set) weak var amount: UILabel!
    
    func configure(_ viewModel: Wallet){
        name.text = viewModel.name
        amount.text = viewModel.amount
    }
}
