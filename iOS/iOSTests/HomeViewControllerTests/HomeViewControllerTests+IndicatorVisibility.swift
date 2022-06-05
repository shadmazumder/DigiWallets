//
//  HomeViewControllerTests+IndicatorVisibility.swift
//  iOSTests
//
//  Created by Shad Mazumder on 2/6/22.
//

import XCTest
import APILayer
import iOS

extension HomeViewControllerTests{
    func test_loadView_showsLoadingIndicator() {
        let (sut, _) = makeSUt()
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    
    func test_clientCompletionForMultipleWalletsFetch_hidesLoadingIndicator() {
        let (sut, client) = makeSUt()
        
        client.completeWithSuccess(anyWalletsWithData.data)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        
        client.completeWithError(.connectivity)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    func test_clientCompletionForMultipleTransactionFetch_hidesLoadingIndicator() {
        let (sut, client) = makeSUt()
        
        client.completeWithSuccess(anyTransactionsData.data, index: 1)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        
        client.completeWithError(.non200HTTPResponse, index: 1)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    func test_clientCompletionOnAnyFetch_hidesLoadingIndicator() {
        let (sut, client) = makeSUt()
        
        sut.simulatePullToRefresh()
        sut.simulatePullToRefresh()
        sut.simulatePullToRefresh()
        sut.simulatePullToRefresh()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        client.completeWithSuccess(anyTransactionsData.data, index: 1)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
        
        sut.simulatePullToRefresh()
        sut.simulatePullToRefresh()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        client.completeWithError(.unexpectedError)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
        
    }
    
    // MARK: - Helper
    private func makeSUt(_ walletsURL: URL? = URL(string: "any-wallets-url")!, _ transactionsURL: URL? = URL(string: "any-transactions-url")!) -> (sut: HomeViewController, clientSpy: ClientSpy){
        let client = ClientSpy()
        let loader = DecodableRemoteLoader(client)
        let errorDelegate = HomeViewControllerDelegateSpy()
        
        let homeViewController = HomeUIComposer.homeComposeWith(loader: loader, errorDelegate: errorDelegate, walletURL: walletsURL, transactionURL: transactionsURL)
        
        trackMemoryLeak(homeViewController)
        trackMemoryLeak(loader)
        trackMemoryLeak(errorDelegate)
        
        homeViewController.loadViewIfNeeded()
        
        return (homeViewController, client)
    }
}
