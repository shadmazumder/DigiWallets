//
//  TransactionViewController.swift
//  iOS
//
//  Created by Shad Mazumder on 5/6/22.
//

import UIKit

public class TransactionViewController: UIViewController {
    @IBOutlet public private(set) weak var transactionDetails: UILabel!
    @IBOutlet public private(set) weak var senderName: UILabel!
    @IBOutlet public private(set) weak var amount: UILabel!
    
    public func update(with transaction: Transaction){
        transactionDetails.text = transaction.description
        senderName.text = transaction.sender
        amount.text = transaction.amount
    }
}