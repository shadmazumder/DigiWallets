//
//  TransactionDetailTests.swift
//  iOSTests
//
//  Created by Shad Mazumder on 5/6/22.
//

import XCTest
import iOS

class TransactionDetailTests: XCTestCase {
    func test_init_rendersNothing() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.transactionDetails.text?.isEmpty, true)
        XCTAssertEqual(sut.senderName.text?.isEmpty, true)
        XCTAssertEqual(sut.amount.text?.isEmpty, true)
    }
    
    private func makeSUT() -> TransactionViewController{
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Transaction", bundle: bundle)
        let transactionDetailViewController = storyboard.instantiateInitialViewController() as! TransactionViewController
        return transactionDetailViewController
    }
}
