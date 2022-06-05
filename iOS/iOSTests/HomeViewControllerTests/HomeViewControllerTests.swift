//
//  HomeViewControllerTests.swift
//  iOSTests
//
//  Created by Shad Mazumder on 30/5/22.
//

import XCTest
import iOS
import CryptoLoader

class HomeViewControllerTests: XCTestCase {
    func test_init_rendersNothing() {
        let (sut, _, _) = makeSUt()
        
        XCTAssertEqual(sut.numberOfWalletsCell + sut.numberOfTransactionsCell, 0)
    }
    
    func test_loadView_returnsErrorOnUnsetURLs() {
        let (_, delegate, _) = makeSUt(nil, nil)
        
        XCTAssertEqual(delegate.errorResult.first?.localizedDescription, HomeViewControllerError.unsetURLs.localizedDescription)
    }
    
    func test_loadView_loadURLsWithoutError() {
        let walletsURL = URL(string: "any-wallets-url")!
        let transactionsURL = URL(string: "any-transactions-url")!
        let (_, delegate, _) = makeSUt(walletsURL, transactionsURL)
        
        XCTAssertTrue(delegate.errorResult.isEmpty)
    }
    
    func test_loadView_deliversErrorsOnClientErrors(){
        let non200HttpError = RemoteLoader.ResultError.non200HTTPResponse
        let connectivityError = RemoteLoader.ResultError.connectivity
        let (sut, delegate, loaderSpy) = makeSUt()
        
        loaderSpy.completeWithError(non200HttpError)
        loaderSpy.completeWithError(connectivityError, index: 1)
        XCTAssertEqual(delegate.errorResult.map({ $0.localizedDescription }), [non200HttpError.localizedDescription, connectivityError.localizedDescription])
        
        delegate.errorResult.removeAll()
        sut.loadViewIfNeeded()
        
        loaderSpy.completeWithError(connectivityError)
        loaderSpy.completeWithError(non200HttpError, index: 1)
        XCTAssertEqual(delegate.errorResult.map({ $0.localizedDescription }), [connectivityError.localizedDescription, non200HttpError.localizedDescription])
    }
    
    func test_loadView_rendersHeader() {
        let headerText = "My Crypto Space"
        let (sut, _, _) = makeSUt()
        sut.title = headerText
        
        XCTAssertEqual(sut.title, headerText)
    }
    
    func test_pullToRefresh_loadsData() {
        let (sut, _, loader) = makeSUt()
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(loader.loadRequest.count, 4)
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(loader.loadRequest.count, 6)
    }
    
    // MARK: - Helper
    func makeSUt(_ walletsURL: URL? = URL(string: "any-wallets-url")!, _ transactionsURL: URL? = URL(string: "any-transactions-url")!) -> (sut: HomeViewController, delegate: HomeViewControllerDelegateSpy, loaderSpy: LoaderSpy){
        let loader = LoaderSpy()
        let errorDelegate = HomeViewControllerDelegateSpy()
        
        let homeViewController = HomeUIComposer.homeComposeWith(loader: loader, errorDelegate: errorDelegate, walletURL: walletsURL, transactionURL: transactionsURL)
        
        trackMemoryLeak(homeViewController)
        trackMemoryLeak(loader)
        trackMemoryLeak(errorDelegate)
        
        homeViewController.loadViewIfNeeded()
        
        return (homeViewController, errorDelegate, loader)
    }
}
