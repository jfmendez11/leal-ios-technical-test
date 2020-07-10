//
//  K.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

// MARK: - Constants used across the app
struct K {
    /// Base url for the API requests
    static let baseURL = "https://mobiletest.leal.co/"
    
    /// Transactions data file path to access the sandbox
    static let transactionsFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Transactions.json")
    
    /// Deleted Transactions data file path to access the sandbox
    static let deleteTransactionsFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("DeletedTransactions.json")
    
    /// Label text in login for animation
    static let loginLabelText = "iOS Technical Test"
    
    /// Number of components in the login UIPickerView
    static let numberOfLoginPickerViewComponents = 1
    
    /// Loging to transactions segue identifier
    static let loginToTransactions = "LoginToTransactions"
    
    /// Transactions to information segue identifier
    static let toTransactionInfo = "TransactionInfo"
    
    /// Show sidebar segue identifier
    static let goToSidebar = "GoToSidebar"
    
    /// Transaction Cell Reuse Identifier
    static let transactionCell = "TransactionCellId"
    
    /// Transaction Cell Nib Name
    static let cellNibName = "TransactionCell"
    
    /// Sidebar Item Cell Reuse Identifier
    static let sidebarItemCell = "SidebarItemCell"
    
    /// Menu Icon Button
    static let menuIcon = "list.bullet"
    
    /// Trash.fill icon
    static let trashIcon = "trash.fill"
    
    /// Change user icon
    static let logoutIcon = "arrow.uturn.left.square"
    
    /// All users selected profile image
    static let allUsersProfileImage = "person.3.fill"
    
    /// Duration for aninmations
    static let animationDuration = 0.75
    
    /// Height for transaction cell when a particular user is selected
    static let transactionCellHeightSingleUser: CGFloat = 80.0
    
    /// Height for transaction cell when all users are selected
    static let transactionCellHeightAllUsers: CGFloat = 90.0
    
    /// Height for delete all cell
    static let deleteAllCellHeight: CGFloat = 30.0
    
    /// Height for sidebar item cell
    static let sidebarItemCellHeight: CGFloat = 40.0
    
    /// Color palette for the app
    struct ColorPelette {
        static let brandYellow = #colorLiteral(red: 0.8257568479, green: 0.6739847064, blue: 0, alpha: 1)
        static let grey = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    /// Different Date Formats and relevant locale information
    struct DateFormats {
        static let ISO8601Format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let ISO8601Locale = "en_US_POSIX"
        static let fullMonthWithRegularDayAndYear = "MMMM dd, yyyy"
    }
    
    /// Multipliers to modify different elements
    struct Multipliers {
        static let frameSizeToCornerRadius: CGFloat = 0.04
        static let shadowOpacityForCard: Float = 0.5
        static let shadowRadiusForCard: CGFloat = 10
        static let cornerRadiusToCircle: CGFloat = 0.5
        static let profileImageBorderWidth: CGFloat = 4
    }
    
    /// User defaults Keys
    struct UserDefaultsKeys {
        static let selectedUser = "CurrentUserId"
    }
}
