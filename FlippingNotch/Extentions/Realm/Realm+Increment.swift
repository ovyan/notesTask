//
//  Realm+Increment.swift
//  rxBalance
//
//  Created by Evgeniy on 15.04.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation
import RealmSwift

public final class RealmSchema: Object {
    // MARK: - Properties
    
    @objc dynamic var className = ""
    @objc dynamic var nextID = 0
    
    // MARK: - Interface
    
    public func incrementID() {
        nextID += 1
    }
    
    // MARK: - Init
    
    public convenience init(with className: String) {
        self.init()
        self.className = className
        nextID = 1
    }
}

open class RealmModel: Object {
    // MARK: - Properties
    
    @objc dynamic var id = nextID()
    
    // MARK: - Realm
    
    open override class func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Internal
    
    static var realm: Realm?
    
    static func nextID() -> Int {
        guard let r = realm else {
            return Int(arc4random())
        }
        return RealmService.nextID(r, for: self)
    }
}
