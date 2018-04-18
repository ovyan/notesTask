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
            
            static let insets = UIEdgeInsets(top: Inset.top, left: Inset.left, bottom: Inset.bot, right: Inset.right)
            
            enum Inset {
                static let top: CGFloat = 0
                
                static let bot: CGFloat = 0
                
                static let left: CGFloat = 16
                
                static let right: CGFloat = 16
            }
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
