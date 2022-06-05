//
//  HomeViewControllerCellRenderingTests.swift
//  iOSTests
//
//  Created by Shad Mazumder on 2/6/22.
//

import XCTest
import APILayer
import iOS

class HomeViewControllerCellRenderingTests: XCTestCase{
    func test_loadWallets_rendersWalletsCellPropertySuccessfully() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
        
        let wallets = anyWalletsWithData.wallets
        
        loader.completeWithSuccess(wallets)
        
        let walletCell = sut.walletCell()
        XCTAssertEqual(walletCell?.name.text, wallets.wallets.first?.walletName)
        XCTAssertEqual(walletCell?.amount.text, wallets.wallets.first?.balance)
    }
    
    func test_loadTransactions_rendersTransferCellPropertySuccessfully() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(sut.numberOfTransactionsCell, 0)
        
        let transactions = anyTransactionsData.history
        
        loader.completeWithSuccess(transactions, index: 1)
        
        let transactionCell = sut.transactionsCell()
        let transaction = transactions.histories.first!
        let details = Transaction.description(from: transaction)
        let amount = Transaction.amount(from: transaction)
        
        XCTAssertEqual(transactionCell?.details.text, details)
        XCTAssertEqual(transactionCell?.amount.text, amount)
    }
    
    func test_loadWithEmptyEntity_rendersNoCell() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
        XCTAssertEqual(sut.numberOfWalletsCell, 0)

        let transactions = Histories(histories: [])
        loader.completeWithSuccess(transactions, index: 1)
        XCTAssertEqual(sut.numberOfTransactionsCell, 0)

        let wallets = Wallets(wallets: [])
        loader.completeWithSuccess(wallets, index: 0)
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
    }
    
    func test_loadFailure_rendersNoCell() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
        
        loader.completeWithError(anyError)
        XCTAssertEqual(sut.numberOfTransactionsCell, 0)

        loader.completeWithError(anyError)
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
    }
    
    func test_refresh_recoversFromFailureState() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
        
        loader.completeWithError(anyError)
        XCTAssertEqual(sut.numberOfTransactionsCell, 0)

        loader.completeWithError(anyError)
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
        
        sut.simulatePullToRefresh()
        
        let wallets = anyWalletsWithData.wallets
        
        loader.completeWithSuccess(wallets)
        
        let walletCell = sut.walletCell()
        XCTAssertEqual(walletCell?.name.text, wallets.wallets.first?.walletName)
        XCTAssertEqual(walletCell?.amount.text, wallets.wallets.first?.balance)
        
        
        let transactions = anyTransactionsData.history
        
        loader.completeWithSuccess(transactions, index: 1)
        
        let transactionCell = sut.transactionsCell()
        let transaction = transactions.histories.first!
        let details = Transaction.description(from: transaction)
        let amount = Transaction.amount(from: transaction)
        
        XCTAssertEqual(transactionCell?.details.text, details)
        XCTAssertEqual(transactionCell?.amount.text, amount)
    }
    
    func test_prepareForReuse_resetProperties() {
        let (sut, loader) = makeSUT()
        loader.completeWithSuccess(anyWalletsWithData.wallets)
        loader.completeWithSuccess(anyTransactionsData.history, index: 1)
        let walletCell = sut.walletCell()
        let transactionCell = sut.transactionsCell()
        
        walletCell?.prepareForReuse()
        
        XCTAssertNil(walletCell?.name.text)
        XCTAssertNil(walletCell?.amount.text)
        
        transactionCell?.prepareForReuse()
        
        XCTAssertNil(transactionCell?.details.text)
        XCTAssertNil(transactionCell?.amount.text)
    }
    
    // MARK: - Helper
    private func makeSUT() -> (sut: HomeViewController, loader: LoaderSpy){
        let loader = LoaderSpy()
        let homeViewController = HomeUIComposer.homeComposeWith(title: nil, loader: loader, errorDelegate: anyHomeViewErrorDelegate, walletURL: anyURL, transactionURL: anyURL, navigationDelegate: anyHomeNavigationDelegate)
        
        homeViewController.loadViewIfNeeded()
        
        trackMemoryLeak(homeViewController)
        trackMemoryLeak(loader)
        
        return (homeViewController, loader)
    }
    
    private var anyError: NSError {NSError(domain: "any-error", code: -1, userInfo: nil)}
}
