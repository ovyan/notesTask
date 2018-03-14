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

    }

    // this is your outlet from Storyboard
    private func didTapAddButton() {
        delegate?.didTapAddButton()
    }
}

protocol CardNoteDelegate: class {
    func didTapAddButton()
}

extension ViewController: CardNoteDelegate {
    func didTapAddButton() {
        print("got this tap in main VC!")
    }
}
