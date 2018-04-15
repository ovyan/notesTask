//
//  TaskModel.swift
//  FlippingNotch
//
//  Created by Evgeniy on 13.04.18.
//  Copyright © 2018 Evgeniy All rights reserved.
//

import Foundation
import RealmSwift

protocol AnyRealmModel: class {
    var id: Int { get }
}

open class RealmModel: Object {
    @objc dynamic var id = Int(arc4random())

    open override class func primaryKey() -> String? {
        return "id"
    }
}

public final class TaskModel: RealmModel {
    // MARK: - Members

    @objc dynamic var createdAt = Date()
    @objc dynamic var text: String = ""
    @objc dynamic var isImportant: Bool = false
}

extension TaskModel {

    public static func create(with text: String, isImportant: Bool) -> TaskModel {
        let model = TaskModel()
        model.text = text
        model.isImportant = isImportant

        return model
    }
}
