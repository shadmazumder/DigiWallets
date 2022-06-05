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
        let sut = TransactionUIComposer.composeTransaction()
        
        sut.loadViewIfNeeded()
        
        XCTAssertNil(sut.transactionDetails.text)
        XCTAssertNil(sut.senderName.text)
        XCTAssertNil(sut.amount.text)
    }
    
    func test_update_rendersDetails(){
        let transaction = Transaction(id: "any id", description: "any description", sender: "any sender", amount: "Any amount")
        let sut = TransactionUIComposer.composeTransaction()
        sut.update(with: transaction)

        sut.loadViewIfNeeded()
        
        
        XCTAssertEqual(sut.transactionDetails.text, transaction.description)
        XCTAssertEqual(sut.senderName.text, transaction.sender)
        XCTAssertEqual(sut.amount.text, transaction.amount)
    }
}
