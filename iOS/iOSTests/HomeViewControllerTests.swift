//
//  HomeViewControllerTests.swift
//  iOSTests
//
//  Created by Shad Mazumder on 30/5/22.
//

import XCTest
import iOS

class HomeViewControllerTests: XCTestCase {
    func test_loadFromStoryboard_returnsHomeViewController() {
        XCTAssertTrue(homeViewControllerFromHomeSotyboard() is HomeViewController, "Initial ViewController is not HomeViewController")
    }
    
    func test_init_rendersNothing() {
        let sut = makeSUt()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.dataSource.snapshot().numberOfItems, 0)
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
