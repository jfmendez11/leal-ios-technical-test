//
//  Extensions.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 9/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

//MARK: - Extensions used across the app

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

//MARK: ImageView Extension
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

//MARK: UINavigationBar Extension
extension UINavigationBar {
    /// Make the large title fit in the NavigationController
    func setupNavigationMultilineTitle(with text: String) {
        self.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: K.ColorPelette.brandYellow, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: K.largeTitleFontSize) ?? UIFont.boldSystemFont(ofSize: K.largeTitleFontSize)]
        for sview in self.subviews {
            for ssview in sview.subviews {
                guard let label = ssview as? UILabel else { break }
                if label.text == text {
                    label.numberOfLines = 2
                    label.lineBreakMode = .byClipping
                    label.adjustsFontSizeToFitWidth = true
                    label.minimumScaleFactor = 0.2
                }
            }
        }
    }
}

//MARK: - UIView Extension
extension UIView {
    /// Standatd animation used across the app
    func showContentAnimation(animations: (() -> (Void))? ) {
        UIView.transition(with: self,
                          duration: K.animationDuration,
                          options: .transitionCrossDissolve,
                          animations: animations,
                          completion: nil
        )
    }
}


//MARK: - NSMutableAttributedString Extension
extension NSMutableAttributedString {
    /// Format string for the card view
    var fontSize:CGFloat { return K.cardLabelFontSize }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
