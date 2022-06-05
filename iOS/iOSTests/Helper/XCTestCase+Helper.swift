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
    func homeViewControllerFromHomeSotyboard() -> UIViewController? {
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Home", bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
    
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
    
    var anyerror: NSError {NSError(domain: "any-error", code: -1, userInfo: nil)}
    
    private class DummyErrorDelegate: HomeViewErrorDelegate{ func handleErrorState(_ error: Error) {} }
    var anyHomeViewErrorDelegate: HomeViewErrorDelegate{ DummyErrorDelegate() }
}
