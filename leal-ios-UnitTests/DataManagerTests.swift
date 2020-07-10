//
//  DataManagerTests.swift
//  leal-ios-UnitTests
//
//  Created by Juan Felipe Méndez on 10/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation
import XCTest

@testable import leal_ios_technical_test

class DataManagerTests: XCTestCase {
    // Expectations to wait for async fetches
    var usersExpectation: XCTestExpectation?
    var userExpectation: XCTestExpectation?
    var transactionsExpectation: XCTestExpectation?
    var transactionInfoExpectation: XCTestExpectation?
    var errorExpectation: XCTestExpectation?
    
    //MARK: - Properties to test
    // Users
    var usersDataManager: DataManager<[User]>!
    var users: [User] = []
    
    var userDataManager: DataManager<User>!
    var user: User?
    
    // Transactions
    var transactionsDataManager: DataManager<[Transaction]>!
    var transactions: [Transaction] = []
    // Transaction info
    var transactionInfoDataManager: DataManager<TransactionInfo>!
    var transactionInfo: TransactionInfo?
    
    var errorCount = 0
    
    //MARK: - Setup
    override func setUp() {
        super.setUp()
        // Users data manager
        usersDataManager = DataManager<[User]>()
        usersDataManager.delegate = self
        
        // User data manager
        userDataManager = DataManager<User>()
        userDataManager.delegate = self
        
        // Transactions data manager
        transactionsDataManager = DataManager<[Transaction]>()
        transactionsDataManager.delegate = self
        
        // Transaction info data manager
        transactionInfoDataManager = DataManager<TransactionInfo>()
        transactionInfoDataManager.delegate = self
        
        // Fetches made inside the app
        // GET: /users
        usersDataManager.fetchData(from: "users")
        // GET: /user/{id}
        userDataManager.fetchData(from: "users/\(1)")
        // GET: /transactions
        transactionsDataManager.fetchData(from: "transactions")
        // GET: /transactions/{id}/info
        transactionInfoDataManager.fetchData(from: "transactions/\(1)/info")
        
        // Wrong URLs
        usersDataManager.fetchData(from: "wrongURL")
        userDataManager.fetchData(from: "wrongURL")
        transactionsDataManager.fetchData(from: "wrongURL")
        transactionInfoDataManager.fetchData(from: "wrongURL")
        
        // Wrong casting
        usersDataManager.fetchData(from: "transactions")
        userDataManager.fetchData(from: "users")
        transactionsDataManager.fetchData(from: "transactions/\(1)/info")
        transactionInfoDataManager.fetchData(from: "users/\(1)")
        
        
        // Create the expectations
        usersExpectation = expectation(description: "Users")
        userExpectation = expectation(description: "User")
        transactionsExpectation = expectation(description: "Transactions")
        transactionInfoExpectation = expectation(description: "TransactionInfo")
        errorExpectation = expectation(description: "Errors")
    }
    
    func testUsers() {
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(users.count > 0)
    }
    
    func testUser() {
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.name, "José Licero")
    }
    
    func testTransactions() {
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(transactions.count > 0)
    }
    
    func testTransactionInfo() {
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(transactionInfo)
    }
    
    func testErrors() {
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(errorCount, 8)
    }
}

//MARK: - DataDelegate Extension
extension DataManagerTests: DataDelegate {
    func didUpdateData(model: Codable) {
        if let usersArray = model as? [User] {
            users = usersArray
            usersExpectation?.fulfill()
        } else if let user_ = model as? User {
            userExpectation?.fulfill()
            user = user_
        } else if let transactionsArray = model as? [Transaction] {
            transactions = transactionsArray
            transactionsExpectation?.fulfill()
        } else if let transaction = model as? TransactionInfo {
            transactionInfo = transaction
            transactionInfoExpectation?.fulfill()
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("didFailWithError")
        if errorCount < 8 {
        errorCount += 1
        }
        if errorCount == 8 {
            print("entro al fulfill")
            errorExpectation?.fulfill()
        }
    }
}
