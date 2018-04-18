//
//  Bool+Extension.swift
//  FlippingNotch
//
//  Created by Evgeniy on 18.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public extension Bool {
    
    public mutating func toggle() {
        self = !self
    }
}
