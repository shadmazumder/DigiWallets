//
//  TransactionUIComposer.swift
//  iOS
//
//  Created by Shad Mazumder on 5/6/22.
//

import UIKit

public class TransactionUIComposer{
    private init(){}
    public static func composeTransaction() -> TransactionViewController{
        TransactionViewController.make()
    }
}

private extension TransactionViewController{
    static func make() -> TransactionViewController{
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Transaction", bundle: bundle)
        let transactionDetailViewController = storyboard.instantiateInitialViewController() as! TransactionViewController
        return transactionDetailViewController
    }
}
