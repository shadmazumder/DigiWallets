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
        XCTAssertTrue(launchesViewControllerFromHomeSotyboard() is HomeViewController, "Initial ViewController is not HomeViewController")
    }
}

// MARK: - Helper
private func launchesViewControllerFromHomeSotyboard() -> UIViewController? {
    let bundle = Bundle(for: HomeViewController.self)
    let storyboard = UIStoryboard(name: "Home", bundle: bundle)
    return storyboard.instantiateInitialViewController()
}
