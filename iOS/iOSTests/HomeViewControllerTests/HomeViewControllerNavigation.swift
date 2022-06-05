//
//  HomeViewControllerNavigation.swift
//  iOSTests
//
//  Created by Shad Mazumder on 5/6/22.
//

import XCTest

class HomeViewControllerNavigation: XCTestCase {
    func test_walletSelection_doesNotNavigate() {
        let (sut, client) = makeSUt()
        client.completeWithSuccess(anyWalletsWithData.data)
        client.completeWithSuccess(anyTransactionsData.data, index: 1)
        
        sut.simulateWalletCellSelection()
        
        XCTAssertEqual(sut.navigationController?.viewControllers.count, 1)
    }
}
