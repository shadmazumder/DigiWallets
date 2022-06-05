//
//  AppComposing.swift
//  MyCryptoAppTests
//
//  Created by Shad Mazumder on 5/6/22.
//

import XCTest

struct Router {
    func startRouting() -> UIViewController{
        UINavigationController()
    }
}

class AppComposing: XCTestCase {
    func test_startRouting_returnsNavigationController() {
        let router = Router()
        let controller = router.startRouting()
        
        XCTAssertTrue(controller is UINavigationController)
    }
}
