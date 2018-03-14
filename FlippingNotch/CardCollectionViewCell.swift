//
//  CardCollectionViewCell.swift
//  FlippingNotch
//
//  Created by Evgeniy on 13.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

protocol CardNoteDelegate: class {
    func didTapAddButton()
}

final class CardCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets

    @IBOutlet var headerView: UIView!

    @IBOutlet var noteTitleLabel: UILabel!

    @IBOutlet var noteTextView: UITextView!

    @IBOutlet var noteTimeLeftLabel: UILabel!

    // MARK: - Setters

    var title: String? { didSet { noteTitleLabel.text = title } }

    var text: String? { didSet { noteTextView.text = text ?? "" } }

    // MARK: - Members

    weak var delegate: CardNoteDelegate?

    // MARK: - Actions

    @IBAction func redBtn(_ sender: UIButton) {
        headerView.backgroundColor = UIColor.rgb(217, 56, 41)
    }

    @IBAction func yellowBtn(_ sender: UIButton) {
        headerView.backgroundColor = UIColor.rgb(251, 199, 0)
    }

    @IBAction func greenBtn(_ sender: UIButton) {
        headerView.backgroundColor = UIColor.rgb(59, 198, 81)
    }

    @IBAction func watchBtnTap(_ sender: UIButton) {
        delegate?.didTapAddButton()
    }
}
