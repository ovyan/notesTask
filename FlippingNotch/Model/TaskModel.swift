//
//  TaskModel.swift
//  FlippingNotch
//
//  Created by Evgeniy on 13.04.18.
//  Copyright © 2018 Evgeniy All rights reserved.
//

import RealmSwift
import UIKit

protocol AnyRealmModel: class {
    var id: Int { get }
}

public final class TaskModel: RealmModel {
    // MARK: - Members

    @objc dynamic var text: String = ""
    @objc dynamic var date = Date()
    @objc dynamic var isImportant: Bool = false
    
    @objc dynamic var width: CGFloat = 119
    @objc dynamic var height: CGFloat = 119
    
    // MARK: - Getters
    
    public var size: CGSize {
        return CGSize.init(width: width, height: height)
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
