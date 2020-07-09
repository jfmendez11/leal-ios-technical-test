//
//  User.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation

/// Represents de model for a user
struct User: Codable {
    let id: Int
    let createdDate: String
    let name: String
    let birthday: String
    let photo: String
}
