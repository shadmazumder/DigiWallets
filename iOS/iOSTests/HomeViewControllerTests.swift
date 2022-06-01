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
        let sut = makeSUt()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.dataSource.snapshot().numberOfItems, 0)
    }
    
    func test_loadView_returnsErrorOnUnsetURLs() {
        let delegate = HomeViewControllerDelegateSpy()
        let sut = makeSUt()
        sut.delegate = delegate
        
        sut.loadViewIfNeeded()

        XCTAssertEqual(delegate.errorResult?.localizedDescription, HomeViewControllerError.unsetURLs.localizedDescription)
    }
    
    func test_loadView_loadUrlsWithoutError() {
        let client = ClientSpy()
        let loader = DecodableRemoteLoader(client)
        let delegate = HomeViewControllerDelegateSpy()
        let walletsURL = URL(string: "any-wallets-url")!
        let transactionURL = URL(string: "any-transactions-url")!
        let sut = makeSUt()
        sut.delegate = delegate
        sut.loader = loader
        sut.walletsURL = walletsURL
        sut.transactions = transactionURL
        
        sut.loadViewIfNeeded()

        XCTAssertNil(delegate.errorResult)
        XCTAssertEqual(client.message.map({$0.url}), [walletsURL, transactionURL])
    }
    
    // MARK: - Helper
    private func makeSUt() -> HomeViewController{
        homeViewControllerFromHomeSotyboard() as! HomeViewController
    }
    
    private func homeViewControllerFromHomeSotyboard() -> UIViewController? {
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Home", bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
}

class ClientSpy: HTTPClient {
    typealias Result = (url: URL, completion: ((HTTPResult) -> Void))
    var message = [Result]()
    
    init() {}
    
    func get(from url: URL, completion: @escaping ((HTTPResult) -> Void)) {
        message.append((url, completion))
    }
    
    func completeWith(_ data: Data, response: HTTPURLResponse, index: Int = 0) {
        message[index].completion(.success(data, response))
    }
    
    func completeWithError(_ error: RemoteLoader.ResultError, index: Int = 0) {
        message[index].completion(.failure(error))
    }
}

class HomeViewControllerDelegateSpy: HomeViewControllerDelegate {
    var errorResult: Error?
    
    func handleErrorState(_ error: Error){
        errorResult = error
    }
}
