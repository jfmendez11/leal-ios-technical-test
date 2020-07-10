//
//  RealmTransaction.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 9/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation
import RealmSwift

/// Represents a transaction
class RealmTransaction: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var createdDate: String = ""
    @objc dynamic var commerce_: RealmCommerce?
    @objc dynamic var branch_: RealmBranch?
    
    var commerce: RealmCommerce {
        get {
            return commerce_ ?? RealmCommerce()
        }
        set {
            commerce_ = newValue
       }
    }
    
    var branch: RealmBranch {
        get {
            return branch_ ?? RealmBranch()
        }
        set {
            branch_ = newValue
       }
    }
    
    /// Custom property to keep track of which transactions have been read
    @objc dynamic var read: Bool = false
    /// Custom property to keep track of which transactions have been deleted
    @objc dynamic var deleted: Bool = false
    
    override static func primaryKey() -> String? {
      return "id"
    }
}

class RealmCommerce: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
      return "id"
    }
}

class RealmBranch: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
      return "id"
    }
}
