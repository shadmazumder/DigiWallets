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
        
        XCTAssertEqual(sut.transactionDetails.text?.isEmpty, true)
        XCTAssertEqual(sut.senderName.text?.isEmpty, true)
        XCTAssertEqual(sut.amount.text?.isEmpty, true)
    }
    
    private func makeSUT() -> TransactionViewController{
        let sut = TransactionUIComposer.composeTransaction()
        sut.loadViewIfNeeded()
        return sut
    }
}

public class TransactionUIComposer{
    private init(){}
    public static func composeTransaction() -> TransactionViewController{
        TransactionViewController.make()
    }
}

private extension TransactionViewController{
    static func make() -> TransactionViewController{
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Transaction", bundle: bundle)
        let transactionDetailViewController = storyboard.instantiateInitialViewController() as! TransactionViewController
        return transactionDetailViewController
    }
}
