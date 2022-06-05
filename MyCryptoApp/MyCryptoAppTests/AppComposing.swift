//
//  AppComposing.swift
//  MyCryptoAppTests
//
//  Created by Shad Mazumder on 5/6/22.
//

import XCTest
import MyCryptoApp
import iOS

struct Router {
    func startRouting() -> UIViewController{
        UINavigationController(rootViewController: HomeViewController())
    }
}

class AppComposing: XCTestCase {
    func test_startRouting_returnsNavigationController() {
        let router = Router()
        let controller = router.startRouting()
        
        XCTAssertTrue(controller is UINavigationController)
    }
    
    func test_startRouting_returnsHomveViewControllerAsRootViewController() {
        let router = Router()
        let controller = router.startRouting()
        let navController = controller as? UINavigationController
        XCTAssertTrue(navController?.viewControllers.first is HomeViewController)
    }
}
