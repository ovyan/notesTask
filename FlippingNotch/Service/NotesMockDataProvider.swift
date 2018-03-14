//
//  NotesMockDataProvider.swift
//  FlippingNotch
//
//  Created by Evgeniy on 14.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

final class NotesMockDataProvider {
    static func notes(_ count: Int = 12) -> [NoteViewModel] {
        var notes = [NoteViewModel]()
        
        for i in 0..<count {
            let str = "\(i + 1)"
            let note = NoteViewModel(title: "Note - \(str)", text: "Text - \(str)", priority: NotePriority.random(), timeLeft: 1337)
            
            notes.append(note)
        }
        
        return notes
    }
    
    static func note() -> NoteViewModel {
        return NoteViewModel(title: "Note - rnd", text: "Text - rnd", priority: NotePriority.random(), timeLeft: 1337)
    }
    
    private init() {}
}
