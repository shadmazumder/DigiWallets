//
//  Router.swift
//  MyCryptoApp
//
//  Created by Shad Mazumder on 5/6/22.
//

import UIKit
import iOS
import APILayer
import CryptoLoader

final class Router {
    private let navigationController: UINavigationController
    private let homeViewController: HomeViewController
    private let transactionViewController: TransactionViewController

    init(navigationDelegate: HomeViewControllerNavigationDelegate, homeErrorDelegate: HomeViewErrorDelegate) {
        let httpClient = URLSessionHTTPClient()
        let decodableLoader = DecodableRemoteLoader(httpClient)
        
        let walletURL = URL(string: "https://demo9767328.mockable.io/wallets")!
        let transactionURL = URL(string: "https://demo9767328.mockable.io/transaction")!
        
        homeViewController = HomeUIComposer.homeComposeWith(title: "My Crypto Space",
                                                            loader: decodableLoader,
                                                            errorDelegate: homeErrorDelegate,
                                                            walletURL: walletURL,
                                                            transactionURL: transactionURL,
                                                            navigationDelegate: navigationDelegate)
        
        navigationController =  UINavigationController(rootViewController: homeViewController)

        transactionViewController = TransactionUIComposer.composeTransaction()
    }

    var startingViewController: UIViewController {
        return navigationController
    }
    
    func navigateToTransaction(_ transaction: Transaction) {
        navigationController.pushViewController(transactionViewController, animated: true)
        transactionViewController.update(with: transaction)
    }
}

extension Router{
    func presentErrorIfApplicable(_ error: Error){
        guard let content = ErrorMapper.alertContent(for: error) else { return }
        alertOn(homeViewController, content: content) {
            // retry implementation
        }
    }
    
    private func alertOn(_ viewController: UIViewController, content: AlertContent, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: content.title,
                                      message: content.message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: content.action, style: .cancel, handler: { _ in
            completion()
        }))

        viewController.present(alert, animated: true, completion: nil)
    }
}

