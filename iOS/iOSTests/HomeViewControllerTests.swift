//
//  HomeViewControllerTests.swift
//  iOSTests
//
//  Created by Shad Mazumder on 30/5/22.
//

import XCTest
import iOS
import CryptoLoader
import APILayer

class HomeViewControllerTests: XCTestCase {
    func test_loadFromStoryboard_returnsHomeViewController() {
        XCTAssertTrue(homeViewControllerFromHomeSotyboard() is HomeViewController, "Initial ViewController is not HomeViewController")
    }
    
    func test_init_rendersNothing() {
        let (sut, _, _) = makeSUt()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.dataSource.snapshot().numberOfItems, 0)
    }
    
    func test_loadView_returnsErrorOnUnsetURLs() {
        let (sut, delegate, _) = makeSUt(nil, nil)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(delegate.errorResult.first?.localizedDescription, HomeViewControllerError.unsetURLs.localizedDescription)
    }
    
    func test_loadView_loadURLsWithoutError() {
        let walletsURL = URL(string: "any-wallets-url")!
        let transactionsURL = URL(string: "any-transactions-url")!
        let (sut, delegate, client) = makeSUt(walletsURL, transactionsURL)
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(delegate.errorResult.isEmpty)
        XCTAssertEqual(client.message.map({$0.url}), [walletsURL, transactionsURL])
    }
    
    func test_loadView_deliversErrorsOnClientErrors(){
        let non200HttpError = RemoteLoader.ResultError.non200HTTPResponse
        let connectivityError = RemoteLoader.ResultError.connectivity
        let (sut, delegate, client) = makeSUt()
        
        sut.loadViewIfNeeded()
        
        client.completeWithError(non200HttpError)
        client.completeWithError(connectivityError, index: 1)
        XCTAssertEqual(delegate.errorResult.map({ $0.localizedDescription }), [non200HttpError.localizedDescription, connectivityError.localizedDescription])
        
        delegate.errorResult.removeAll()
        sut.loadViewIfNeeded()
        
        client.completeWithError(connectivityError)
        client.completeWithError(non200HttpError, index: 1)
        XCTAssertEqual(delegate.errorResult.map({ $0.localizedDescription }), [connectivityError.localizedDescription, non200HttpError.localizedDescription])
    }
    
    func test_loadView_redndersCellOnClientSuccess() {
        let (sut, delegate, client) = makeSUt()
        sut.loadViewIfNeeded()

        client.completeWithSuccess(anyWalletsWithData.data)
        client.completeWithSuccess(anyTransactionsData.data, index: 1)
        
        XCTAssertTrue(delegate.errorResult.isEmpty)
        XCTAssertNotNil(sut.cell)
    }
    
    func test_loadView_rendersHeader() {
        let headerText = "My Crypto Space"
        let (sut, _, _) = makeSUt()
        sut.title = headerText
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, headerText)
    }
    
    func test_pullToRefresh_loadsData() {
        let (sut, _, client) = makeSUt()
        sut.loadViewIfNeeded()
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(client.message.count, 4)
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(client.message.count, 6)
    }
    
    // MARK: - Helper
    private func makeSUt(_ walletsURL: URL? = URL(string: "any-wallets-url")!, _ transactionsURL: URL? = URL(string: "any-transactions-url")!) -> (sut: HomeViewController, delegate: HomeViewControllerDelegateSpy, client: ClientSpy){
        let client = ClientSpy()
        let loader = DecodableRemoteLoader(client)
        let delegate = HomeViewControllerDelegateSpy()
        let homeViewController = homeViewControllerFromHomeSotyboard() as! HomeViewController
        
        homeViewController.delegate = delegate
        homeViewController.loader = loader
        
        homeViewController.walletsURL = walletsURL
        homeViewController.transactionsURL = transactionsURL
        
        trackMemoryLeak(homeViewController)
        trackMemoryLeak(client)
        trackMemoryLeak(loader)
        trackMemoryLeak(delegate)
        
        return (homeViewController, delegate, client)
    }
    
    private func homeViewControllerFromHomeSotyboard() -> UIViewController? {
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Home", bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
    
    private var anyWalletsWithData: (wallets: Wallets, data: Data){
        let anyWallet = Wallet(id: "any-ID", walletName: "Any Name", balance: "any-balance")
        let wallets = Wallets(wallets: [anyWallet])
        
        return (wallets, encodedData(wallets))
    }
    
    private func encodedData<T: Encodable>(_ model: T) -> Data{
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try! encoder.encode(model)
    }
    
    private var anyTransactionsData: (history: Histories, data: Data){
        let anyTransaction = Transaction(id: "anyID", entry: "AnyEntry", amount: "anyAmount", currency: "AnyCurrency", sender: "AnySender", recipient: "AnyRecipient")
        let histories = Histories(histories: [anyTransaction])
        
        return (histories, encodedData(histories))
    }
}
