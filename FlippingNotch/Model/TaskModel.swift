//
//  TaskModel.swift
//  FlippingNotch
//
//  Created by Evgeniy on 13.04.18.
//  Copyright © 2018 Evgeniy All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmModel: class {
    var pKey: Int { get }
}

public final class TaskModel: Object, RealmModel {
    // MARK: - Members

    @objc dynamic var pKey = Int(arc4random())
    @objc dynamic var createdAt = Date()
    @objc dynamic var text: String = ""
    @objc dynamic var isImportant: Bool = false

    public override class func primaryKey() -> String? {
        return "pKey"
    }
}

extension TaskModel {

    public static func create(with text: String, isImportant: Bool) -> TaskModel {
        let model = TaskModel()
        model.text = text
        model.isImportant = isImportant

        return model
    }
}
