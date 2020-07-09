//
//  CustomCardView.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 8/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

/// Custom View in order to create shadow effect
class CustomCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpView()
    }
    
    private func setUpView() {
        layer.cornerRadius = frame.size.height * K.Multipliers.frameSizeToCornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = K.Multipliers.shadowOpacityForCard
        layer.shadowOffset = .zero
        layer.shadowRadius = K.Multipliers.shadowRadiusForCard
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }

}
