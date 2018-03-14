//
//  NoteViewModel.swift
//  FlippingNotch
//
//  Created by Evgeniy on 14.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

struct NoteViewModel {
    let title: String
    let text: String
    let priority: NotePriority
    let timeLeft: Double
}

enum NotePriority: Int {
    case low = 0, mid, high
}

extension NotePriority {
    static func random() -> NotePriority {
        let idx = arc4random_uniform(3)

        return NotePriority(rawValue: Int(idx))!
    }
}
