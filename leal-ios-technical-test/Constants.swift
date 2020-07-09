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
    
    /// Transactions to information segue identifier
    static let toTransactionInfo = "TransactionInfo"
    
    /// Transaction Cell Reuse Identifier
    static let transactionCell = "TransactionCellId"
    
    /// Transaction Cell Nib Name
    static let cellNibName = "TransactionCell"
    
    /// Menu Icon Button
    static let menuIcon = "list.bullet"
    
    /// Trash.fill icon
    static let trashIcon = "trash.fill"
    
    /// Duration for aninmations
    static let animationDuration = 0.75
    
    /// Height for transaction cell when a particular user is selected
    static let transactionCellHeightSingleUser: CGFloat = 80.0
    
    /// Height for transaction cell when all users are selected
    static let transactionCellHeightAllUsers: CGFloat = 90.0
    
    /// Height for delete all cell
    static let deleteAllCellHeight: CGFloat = 30.0
    
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

//MARK: - Extensions

//MARK: String Extension
extension String {
    /// Return a string with the desired format, if the string can transform into a date
    func formatDateFromSelf(to format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.DateFormats.ISO8601Format
        dateFormatter.locale = Locale(identifier: K.DateFormats.ISO8601Locale)
        if let date = dateFormatter.date(from: self) {
            let returnFormatter = DateFormatter()
            returnFormatter.dateFormat = format
            returnFormatter.locale = .current
            return returnFormatter.string(from: date)
        }
        return nil
    }
}

//MARK: Array Extension
extension Array {
    /// Convert an array into a dictionary
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}

//MARK: ImageView Ectension
extension UIImageView {
    /// Create a custimized circular image, with brand's color border
    func generateCirledImage(from data: Data?) {
        if let imageData = data {
            self.image = UIImage(data: imageData)
            self.layer.cornerRadius = self.frame.height * K.Multipliers.cornerRadiusToCircle
            self.contentMode = .scaleAspectFill
            self.clipsToBounds = true
            self.layer.borderColor = K.ColorPelette.brandYellow.cgColor
            self.layer.borderWidth = K.Multipliers.profileImageBorderWidth
        }
    }
}

//MARK: UINavigationItem Extension
extension UINavigationItem {
    /// Make the title fit in the NavigationController
    func setTitleLabel(with text: String) {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = K.ColorPelette.brandYellow
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.text = text
        self.titleView = label
    }
}
