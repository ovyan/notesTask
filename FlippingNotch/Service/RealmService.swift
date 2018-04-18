//
//  RealmService.swift
//  FlippingNotch
//
//  Created by Evgeniy on 13.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RealmSwift

public typealias RealmUpdateBlock<Model> = (_ model: Model) -> Void

public final class RealmService {
    // MARK: - Members
    
    /// Thread safe instance of `Realm`.
    public var realm: Realm {
        return try! Realm()
    }
    
    /// Shared Instance of this service.
    public static let shared = RealmService()
    
    /// Realm will perform its operations on this queue by default.
    private let queue: DispatchQueue
    
    // MARK: - Interface
    
    // MARK: - Fetch
    
    public func models<Model: Object>(of type: Model.Type) -> Results<Model> {
        return realm.objects(type)
    }
    
    public func fetchAll<Model: Object>() -> Results<Model> {
        return realm.objects(Model.self)
    }
    
    // MARK: - Save
    
    public func save<Model: Object>(_ model: Model) {
        perform(transaction: { realm.add(model) })
    }
    
    public func save<Model: Object>(_ models: [Model]) {
        perform(transaction: { realm.add(models) })
    }
    
    public func perform(transaction: VoidBlock) {
        try? realm.write(transaction)
    }
    
    public func updateAsync<Model: Object>(_ model: Model, _ block: @escaping RealmUpdateBlock<Model>) {
        let ref = ThreadSafeReference(to: model)
        queue.async {
            let realm = self.realm
            guard let resolved = realm.resolve(ref) else { return }
            
            try? realm.write {
                block(resolved)
            }
        }
    }
    
    // MARK: - Init
    
    private init() {
        queue = DispatchQueue(label: "service.realm.background", qos: .utility, attributes: .concurrent)
        
        let path = Realm.Configuration.defaultConfiguration.fileURL!.path
        print(path)
    }
}

// MARK: - Auto Increment

extension RealmService {
    
    public static func nextID<Model: Object>(_ realm: Realm, for modelType: Model.Type) -> Int {
        let className = String(describing: modelType)
        guard let scheme = realm.objects(RealmSchema.self).filter("className = %@", className).first else {
            let newModel = RealmSchema(with: className)
            try? realm.write { realm.add(newModel) }
            
            return 0
        }
        let currentID = scheme.nextID
        try? realm.write { scheme.incrementID() }
        
        return currentID
    }
}
