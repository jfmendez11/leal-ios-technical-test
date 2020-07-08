//
//  K.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation

// MARK: -Constants used across the app
struct K {
    /// Base url for the API requests
    static let baseURL = "https://mobiletest.leal.co/"
    
    /// Label text in login for animation
    static let loginLabelText = "iOS Technical Test"
    
    /// Number of components in the login UIPickerView
    static let numberOfLoginPickerViewComponents = 1
    
    /// Loging to transactions segue identifier
    static let loginToTransactions = "LoginToTransactions"
    
    /// Transaction Cell Reuse Identifier
    static let transactionCell = "TransactionCell"
    
    /// Menu Icon Button
    static let menuIcon = "list.bullet"
    
    /// User defaults Keys
    struct UserDefaultsKeys {
        static let selectedUser = "CurrentUserId"
    }
}
