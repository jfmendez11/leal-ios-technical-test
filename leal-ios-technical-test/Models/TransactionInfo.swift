//
//  TransactionInfo.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation

/// Represents the info of a given transaction
struct TransactionInfo: Codable {
    let transactionId: Int
    let value: Int
    let points: Int
}
