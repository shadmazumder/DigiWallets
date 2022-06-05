//
//  XCTestCase+Helper.swift
//  iOSTests
//
//  Created by Shad Mazumder on 1/6/22.
//

import XCTest
import APILayer
import iOS

extension XCTestCase{
    var anyWalletsWithData: (wallets: Wallets, data: Data){
        let anyWallet = WalletAPIModel(id: "any-ID", walletName: "Any Name", balance: "any-balance")
        let wallets = Wallets(wallets: [anyWallet])
        
        return (wallets, encodedData(wallets))
    }
    
    private func encodedData<T: Encodable>(_ model: T) -> Data{
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try! encoder.encode(model)
    }
    
    var anyTransactionsData: (history: Histories, data: Data){
        let anyTransaction = TransactionAPIModel(id: "anyID", entry: "AnyEntry", amount: "anyAmount", currency: "AnyCurrency", sender: "AnySender", recipient: "AnyRecipient")
        let histories = Histories(histories: [anyTransaction])
        
        return (histories, encodedData(histories))
    }
    
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Memory Leak!!! Didn't deallocated", file: file, line: line)
        }
    }
    
    var anyURL: URL { URL(string: "any-url")! }
    
    private class DummyErrorDelegate: HomeViewErrorDelegate{ func handleErrorState(_ error: Error) {} }
    var anyHomeViewErrorDelegate: HomeViewErrorDelegate{ DummyErrorDelegate() }
    
    private class DummyNavRouter: HomeViewControllerNavigationDelegate{
        func navigateToTransactionDetails(_ transaction: Transaction) {}
    }
    var anyHomeNavigationDelegate: HomeViewControllerNavigationDelegate { DummyNavRouter() }
    
    func makeSUt(_ walletsURL: URL? = URL(string: "any-wallets-url")!, _ transactionsURL: URL? = URL(string: "any-transactions-url")!) -> (sut: HomeViewController, clientSpy: ClientSpy){
        let client = ClientSpy()
        let loader = DecodableRemoteLoader(client)
        let errorDelegate = anyHomeViewErrorDelegate
        
        let homeViewController = HomeUIComposer.homeComposeWith(title: nil, loader: loader, errorDelegate: errorDelegate, walletURL: walletsURL, transactionURL: transactionsURL, navigationDelegate: anyHomeNavigationDelegate)
        
        trackMemoryLeak(homeViewController)
        trackMemoryLeak(loader)
        trackMemoryLeak(errorDelegate)
        
        homeViewController.loadViewIfNeeded()
        
        return (homeViewController, client)
    }
}
