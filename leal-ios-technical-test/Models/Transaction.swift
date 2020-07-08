//
//  Transaction.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation

/// Represents a transaction
struct Transaction: Codable {
    let id: Int
    let userId: Int
    let createdDate: String
    let commerce: Commerce
    let branch: Branch
}
