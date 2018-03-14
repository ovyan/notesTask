//
//  NotesMockDataProvider.swift
//  FlippingNotch
//
//  Created by Evgeniy on 14.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

final class NotesMockDataProvider {
    static func notes() -> [NoteViewModel] {
        var notes = [NoteViewModel]()
        let count = 12
        
        for i in 0..<count {
            let str = "\(i + 1)"
            let note = NoteViewModel(title: "Note - \(str)", text: "Text - \(str)", priority: NotePriority.random(), timeLeft: 1337)
            
            notes.append(note)
        }
        
        return notes
    }
    
    private init() {}
}
