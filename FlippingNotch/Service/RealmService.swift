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

    public static let shared = RealmService()

    public var realm: Realm {
        return try! Realm()
    }

    // MARK: - Interface

    public func update<Model: Object>(_ model: Model, _ block: @escaping (_ model: Model) -> Void) {
        let ref = ThreadSafeReference(to: model)
        queue.async {
            let realm = self.realm
            
            guard let resolved = realm.resolve(ref) else { return }
            try? realm.write {
                block(resolved)
            }
        }
    }

    public func update(_ block: @escaping () -> Void) {
        queue.async {
            try? self.realm.write(block)
        }
    }

    public func save<Model: Object>(_ object: Model) {
        try? realm.write {
            realm.add(object)
        }
    }

    public func getAll<Model: Object>() -> Results<Model> {
        return realm.objects(Model.self)
    }

    // MARK: - Internal

    private let queue = DispatchQueue(label: "service.realm.background", qos: .utility, attributes: .concurrent)

    // MARK: - Init

    private init() {
        print("realm located at: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
}
