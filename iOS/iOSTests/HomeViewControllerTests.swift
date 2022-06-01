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
    var errorResult = [Error]()
    
    func handleErrorState(_ error: Error){
        errorResult.append(error)
    }
}

extension XCTestCase{
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Memory Leak!!! Didn't deallocated", file: file, line: line)
        }
    }
}
