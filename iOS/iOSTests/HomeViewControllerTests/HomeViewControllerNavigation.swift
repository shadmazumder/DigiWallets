//
//  HomeViewControllerNavigation.swift
//  iOSTests
//
//  Created by Shad Mazumder on 5/6/22.
//

import XCTest
import CryptoLoader
import APILayer
import iOS

class HomeViewControllerNavigation: XCTestCase {
    func test_walletSelection_doesNotNavigate() {
        let (sut, client, navigationSpy) = makeSUt()
        client.completeWithSuccess(anyWalletsWithData.data)
        client.completeWithSuccess(anyTransactionsData.data, index: 1)
        
        sut.simulateWalletCellSelection()
        
        XCTAssertEqual(navigationSpy.count, 0)
    }
    
    func test_TransactionSelection_navigatesToDetailsScreen() {
        let (sut, client, navigationSpy) = makeSUt()
        client.completeWithSuccess(anyWalletsWithData.data)
        client.completeWithSuccess(anyTransactionsData.data, index: 1)
        
        sut.simulateTransactionCellSelection()
        
        XCTAssertEqual(navigationSpy.count, 1)
    }
    
    // MARK: - Helper
    private func makeSUt() -> (sut: HomeViewController, clientSpy: ClientSpy, navigationSpy: NavigationSpy){
        let client = ClientSpy()
        let loader = DecodableRemoteLoader(client)
        let navigationSpy = NavigationSpy()
        let errorDelegate = anyHomeViewErrorDelegate
        
        let homeViewController = HomeUIComposer.homeComposeWith(title: nil, loader: loader, errorDelegate: errorDelegate, walletURL: URL(string: "any-wallets-url")!, transactionURL: URL(string: "any-transactions-url")!, navigationDelegate: navigationSpy)
        
        trackMemoryLeak(homeViewController)
        trackMemoryLeak(loader)
        trackMemoryLeak(errorDelegate)
        
        homeViewController.loadViewIfNeeded()
        
        return (homeViewController, client, navigationSpy)
    }
}

private class NavigationSpy: HomeViewControllerNavigationDelegate{
    var count = 0
    func navigateToTransactionDetails(_ transaction: Transaction) {
        count += 1
    }
}
