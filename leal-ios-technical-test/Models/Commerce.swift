//
//  Commerce.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation

/// Represents a commerce
struct Commerce: Codable {
    let id: Int
    let name: String
    let branches: [Branch]
    let valueToPoints: Int
}
