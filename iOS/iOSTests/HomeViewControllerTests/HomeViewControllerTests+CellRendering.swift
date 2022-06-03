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
