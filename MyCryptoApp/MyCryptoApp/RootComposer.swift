//
//  RootComposer.swift
//  MyCryptoApp
//
//  Created by Shad Mazumder on 5/6/22.
//

import UIKit
import iOS

class RootComposer {
    private var router: Router?
    
    init() {
        router = Router(navigationDelegate: self, homeErrorDelegate: self)
    }
    
    var startingViewController: UIViewController { router!.startingViewController }
}

extension RootComposer: HomeViewControllerNavigationDelegate, HomeViewErrorDelegate{
    func handleErrorState(_ error: Error) {
        
    }
    
    func navigateToTransactionDetails(_ transaction: Transaction) {
        router?.navigateToTransaction(transaction)
    }
}
