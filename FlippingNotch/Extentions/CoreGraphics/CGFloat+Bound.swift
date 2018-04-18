//
//  CGFloat+Bound.swift
//  FlippingNotch
//
//  Created by Evgeniy on 18.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import CoreGraphics

public extension CGFloat {

    public func leftBound(to value: CGFloat) -> CGFloat {
        return self < value ? value : self
    }
}
