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
    
    func test_loadWalletsCompletion_rendersWalletsCellSuccessfully() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfWalletsCell, 0)
        
        loader.completeWithSuccess(anyWalletsWithData.wallets)
        XCTAssertEqual(sut.numberOfWalletsCell, 1)
    }
    
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
