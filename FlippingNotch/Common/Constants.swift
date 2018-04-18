//
//  Constants.swift
//  FlippingNotch
//
//  Created by Evgeniy on 18.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

enum CUI {
    enum Feed {
        enum Card {

            static let textViewHeight: CGFloat = 70

            static let toolbarHeight: CGFloat = 44

            static let headerHeight: CGFloat = 6

            static let baseHeight: CGFloat = toolbarHeight + headerHeight

            static let height: CGFloat = baseHeight + textViewHeight
        }
    }
}

enum Constants {
    enum Color {}

    enum Notch {
        static let notchWidth: CGFloat = 209
        // static let notchHeight: CGFloat = 26
        static let notchHeight: CGFloat = 0
        static let maxScrollOffset: CGFloat = -86
        // static let notchViewTopInset: CGFloat = 40
        static let notchViewTopInset: CGFloat = 0
    }
}
