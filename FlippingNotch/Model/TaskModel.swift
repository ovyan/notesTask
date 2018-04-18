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

public final class TaskModel: RealmModel {
    // MARK: - Members

    @objc dynamic var text: String = ""
    @objc dynamic var date = Date()
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
