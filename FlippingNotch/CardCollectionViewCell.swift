//
//  CardCollectionViewCell.swift
//  FlippingNotch
//
//  Created by Evgeniy on 13.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets

    @IBOutlet var headerView: UIView!
    
    @IBAction func redBtn(_ sender: UIButton) {
        headerView.backgroundColor = UIColor.init(red: 217, green: 56, blue: 41, alpha: 1)
    }
    @IBAction func yellowBtn(_ sender: UIButton) {
        headerView.backgroundColor = UIColor.init(red: 251, green: 199, blue: 0, alpha: 1)
    }
    @IBAction func greenBtn(_ sender: UIButton) {
        headerView.backgroundColor = UIColor.init(red: 59, green: 198, blue: 81, alpha: 1)
    }
}
