//
//  HomeViewControllerTests+CellRendering.swift
//  iOSTests
//
//  Created by Shad Mazumder on 2/6/22.
//

import XCTest
import CryptoLoader
import APILayer
import iOS

class HomeViewControllerCellRenderingTests: XCTestCase{
    func test_loadWallets_rendersWalletsCellPropertySuccessfully() {
        let (sut, loader) = makeSUT()
        let wallets = anyWalletsWithData.wallets

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
        
        
        loader.completeWithSuccess(wallets)
        
        let walletCell = sut.walletCell()
        XCTAssertEqual(walletCell?.name.text, wallets.wallets.first?.walletName)
        XCTAssertEqual(walletCell?.amount.text, wallets.wallets.first?.balance)
    }
    
    func test_loadTransactions_rendersTransferCellPropertySuccessfully() {
        let (sut, loader) = makeSUT()
        let transactions = anyTransactionsData.history

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfTransactionsCell, 0)
        
        
        loader.completeWithSuccess(transactions, index: 1)
        
        let transactionCell = sut.transactionsCell()
        let transaction = transactions.histories.first!
        let details = TransactionViewModel.description(from: transaction)
        let amount = TransactionViewModel.amount(from: transaction)
        
        XCTAssertEqual(transactionCell?.details.text, details)
        XCTAssertEqual(transactionCell?.amount.text, amount)
    }
    
    func test_loadWithEmptyEntity_rendersNoCell() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
        XCTAssertEqual(sut.numberOfWalletsCell, 0)

        let transactions = Histories(histories: [])
        loader.completeWithSuccess(transactions, index: 1)
        XCTAssertEqual(sut.numberOfTransactionsCell, 0)

        let wallets = Wallets(wallets: [])
        loader.completeWithSuccess(wallets, index: 0)
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
    }
    
    // MARK: - Helper
    private func makeSUT() -> (sut: HomeViewController, LoaderSpy){
        let homeViewController = homeViewControllerFromHomeSotyboard() as! HomeViewController
        let loader = LoaderSpy()
        homeViewController.loader = loader
        
        let anyURL = URL(string: "any-url")!
        homeViewController.walletsURL = anyURL
        homeViewController.transactionsURL = anyURL
        
        trackMemoryLeak(homeViewController)
        trackMemoryLeak(loader)
        
        return (homeViewController, loader)
    }
}

class LoaderSpy: DecodableLoader {
    var loadRequest = [((DecodableResult) -> Void)]()
    
    func load<T>(from url: URL, of type: T.Type, completion: @escaping ((DecodableResult) -> Void)) where T : Decodable {
        loadRequest.append(completion)
    }
    
    func completeWithSuccess(_ decodableModel: Decodable, index: Int = 0){
        loadRequest[index](.success(decodableModel))
    }
}
