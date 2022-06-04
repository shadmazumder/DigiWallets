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
    func makeSUt(_ walletsURL: URL? = URL(string: "any-wallets-url")!, _ transactionsURL: URL? = URL(string: "any-transactions-url")!) -> (sut: HomeViewController, delegate: HomeViewControllerDelegateSpy, client: ClientSpy){
        let client = ClientSpy()
        let loader = DecodableRemoteLoader(client)
        let errorDelegate = HomeViewControllerDelegateSpy()
        
        let homeViewController = HomeUIComposer.homeComposeWith(loader: loader, errorDelegate: errorDelegate, walletURL: walletsURL, transactionURL: transactionsURL)
        
//        trackMemoryLeak(homeViewController)
//        trackMemoryLeak(client)
//        trackMemoryLeak(loader)
//        trackMemoryLeak(errorDelegate)
        
        homeViewController.loadViewIfNeeded()
        
        return (homeViewController, errorDelegate, client)
    }
}
