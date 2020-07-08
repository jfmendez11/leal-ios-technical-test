//
//  K.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

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
    static let transactionCell = "TransactionCellId"
    
    /// Transaction Cell Nib Name
    static let cellNibName = "TransactionCell"
    
    /// Menu Icon Button
    static let menuIcon = "list.bullet"
    
    /// Height for transaction cell when a particular user is selected
    static let transactionCellHeightSingleUser: CGFloat = 80.0
    
    /// Height for transaction cell when all users are selected
    static let transactionCellHeightAllUsers: CGFloat = 90.0
    
    /// Color palette for the app
    struct ColorPelette {
        static let brandYellow = #colorLiteral(red: 0.8257568479, green: 0.6739847064, blue: 0, alpha: 1)
        static let grey = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    /// User defaults Keys
    struct UserDefaultsKeys {
        static let selectedUser = "CurrentUserId"
    }
}
