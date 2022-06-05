//
//  TransactionDetailTests.swift
//  iOSTests
//
//  Created by Shad Mazumder on 5/6/22.
//

import XCTest
import iOS

class TransactionDetailTests: XCTestCase {
    func test_init_rendersNoDetails() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.transactionDetails.text?.isEmpty, true)
        XCTAssertEqual(sut.senderName.text?.isEmpty, true)
        XCTAssertEqual(sut.amount.text?.isEmpty, true)
    }
    
    func test_update_rendersDetails(){
        let transaction = Transaction(id: "any id", description: "any description", sender: "any sender", amount: "Any amount")
        
        let sut = makeSUT()
        sut.update(with: transaction)
        
        XCTAssertEqual(sut.transactionDetails.text, transaction.description)
        XCTAssertEqual(sut.senderName.text, transaction.sender)
        XCTAssertEqual(sut.amount.text, transaction.amount)
    }
    
    // MARK: - Helper
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
