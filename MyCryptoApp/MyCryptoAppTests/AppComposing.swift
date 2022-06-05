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
    func test_startRouting_returnsHomveViewControllerAsRootViewController() {
        let (_, navController ) = makeSUT()
        XCTAssertTrue(navController.viewControllers.first is HomeViewController)
    }
    
    // MARK: - Helper
    func makeSUT() -> (router: Router, navigationController: UINavigationController){
        let router = Router()
        let controller = router.startRouting()
        return (router, controller as! UINavigationController)
    }
}
