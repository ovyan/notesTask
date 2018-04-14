//
//  RealmService.swift
//  FlippingNotch
//
//  Created by Evgeniy on 13.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RealmSwift

public final class RealmService {
    // MARK: - Members

    public var realm: Realm {
        return try! Realm()
    }

    // MARK: - Interface

    public func write(_ block: () -> Void) {
        try? realm.write(block)
    }

    public func save<Model: Object>(_ object: Model) {
        try? realm.write {
            realm.add(object)
        }
    }

    public func getAll<Model: Object>() -> Results<Model> {
        return realm.objects(Model.self)
    }

    // MARK: - Init

    public init() {
        print("realm located at: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
}
