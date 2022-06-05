//
//  HomeViewControllerSectionHeader.swift
//  iOSTests
//
//  Created by Shad Mazumder on 5/6/22.
//

import XCTest
import CryptoLoader
import APILayer
import iOS

class HomeViewControllerSectionHeader: XCTestCase {
    func test_successLoad_rendersSectionHeader() {
        let (sut, clientSpy) = makeSUt()
        
        clientSpy.completeWithSuccess(anyWalletsWithData.data)
        clientSpy.completeWithSuccess(anyTransactionsData.data, index: 1)

        let walletHeader = sut.tableView.dataSource?.tableView?(sut.tableView, titleForHeaderInSection: sut.section(for: .wallets))
        let transactionHeader = sut.tableView.dataSource?.tableView?(sut.tableView, titleForHeaderInSection: sut.section(for: .transaction))

        XCTAssertEqual(walletHeader, HomeViewSection.wallets.rawValue)
        XCTAssertEqual(transactionHeader, HomeViewSection.transaction.rawValue)
    }
    
    func test_ErrorLoad_rendersSectionHeader() {
        let (sut, clientSpy) = makeSUt()
        
        clientSpy.completeWithError(.unexpectedError)
        clientSpy.completeWithError(.connectivity, index: 0)

        let walletHeader = sut.tableView.dataSource?.tableView?(sut.tableView, titleForHeaderInSection: sut.section(for: .wallets))
        let transactionHeader = sut.tableView.dataSource?.tableView?(sut.tableView, titleForHeaderInSection: sut.section(for: .transaction))

        XCTAssertEqual(walletHeader, HomeViewSection.wallets.rawValue)
        XCTAssertEqual(transactionHeader, HomeViewSection.transaction.rawValue)
    }
}
