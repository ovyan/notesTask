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

public typealias TapHandler = VoidBlock
public typealias CardTapHandler = (TaskModel) -> Void

final class CardCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets

    @IBOutlet var headerView: UIView!

    @IBOutlet var noteTitleLabel: UILabel!

    @IBOutlet var noteTextView: UITextView!

    @IBOutlet var noteTimeLeftLabel: UILabel!

    // MARK: - Members

    weak var delegate: CardNoteDelegate?

    public var textViewTapHandler: CardTapHandler?

    // MARK: - Setters

    var model: TaskModel? {
        didSet {
            guard let model = model else { return }
            onModelSet(model)
        }
    }

    // MARK: - Tap Handler

    override func awakeFromNib() {
        super.awakeFromNib()

        setTextViewTapHandler()
    }

    private func setTextViewTapHandler() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTextViewTap(_:)))
        noteTextView!.addGestureRecognizer(tap)
    }

    @objc
    private func onTextViewTap(_ sender: UITapGestureRecognizer) {
        noteTextView.becomeFirstResponder()
        textViewTapHandler?(model!)
    }

    // MARK: - Internal

    private func onModelSet(_ model: TaskModel) {
        noteTitleLabel.text = "Some title"
        noteTextView.text = model.text
        headerView.backgroundColor = model.isImportant ? .red : .green
    }

    // MARK: - Actions

    @IBAction func greenBtn(_ sender: UIButton) { // Actually a red btn
        headerView.backgroundColor = UIColor.rgb(59, 198, 81)
    }

    @IBAction func watchBtnTap(_ sender: UIButton) {
        delegate?.didTapAddButton()
    }
}
