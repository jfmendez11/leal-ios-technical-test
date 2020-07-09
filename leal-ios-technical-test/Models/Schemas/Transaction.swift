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
    
    /// Custom property to keep track of which transactions have been read
    var read: Bool = false
    
    /// Coding keys to make the API request
    enum CodingKeys: String, CodingKey {
        case id, userId, createdDate, commerce, branch
    }
}
