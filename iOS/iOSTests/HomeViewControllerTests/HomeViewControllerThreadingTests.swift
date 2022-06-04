//
//  HomeViewControllerThreadingTests.swift
//  iOSTests
//
//  Created by Shad Mazumder on 4/6/22.
//

import XCTest
import iOS
import APILayer

class HomeViewControllerThreadingTests: XCTestCase {
//    func test_loadRemoteCompletion_dispatchFromBackgroundToUIthread() {
//        let (sut, loader) = makeSUT()
//        sut.loadViewIfNeeded()
//
//        let exp = expectation(description: "Waiting for Backgound queue")
//        let wallets = self.anyWalletsWithData.wallets
//        DispatchQueue.global().async {
//            loader.completeWithSuccess(wallets)
//            exp.fulfill()
//        }
//        
//        wait(for: [exp], timeout: 0.5)
//    }
    
    // MARK: - Helper
//    private func makeSUT() -> (sut: HomeViewController, LoaderSpy){
//        let loader = LoaderSpy()
//        let homeViewController = HomeUIComposer.homeComposeWith(loader: loader, delegate: HomeViewControllerDelegateSpy())
//        
//        let anyURL = URL(string: "any-url")!
//        homeViewController.walletsURL = anyURL
//        homeViewController.transactionsURL = anyURL
//        
//        trackMemoryLeak(homeViewController)
//        trackMemoryLeak(loader)
//        
//        homeViewController.loadViewIfNeeded()
//        
//        return (homeViewController, loader)
//    }
}
