//
//  CardCollectionViewCell.swift
//  FlippingNotch
//
//  Created by Evgeniy on 13.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

public protocol NoteInteractionDelegate: class {
    func didTapAddButton()

    func shouldInvalidateLayout()
}

public typealias TapHandler = VoidBlock
public typealias CardTapHandler = (TaskModel) -> Void

public final class CardCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets

    @IBOutlet var headerView: UIView!

    @IBOutlet var noteTitleLabel: UILabel!

    @IBOutlet var noteTextView: UITextView!

    @IBOutlet var noteTimeLeftLabel: UILabel!

    // MARK: - Overrides

    public override func awakeFromNib() {
        super.awakeFromNib()

        observeTextView()
    }

    public override var intrinsicContentSize: CGSize {
        return noteTextView.intrinsicContentSize
    }

    // MARK: - Members

    public weak var interactionDelegate: NoteInteractionDelegate?

    // MARK: - Setters

    var model: TaskModel? {
        didSet {
            guard let model = model else { return }
            updateView(with: model)
        }
    }

    // MARK: - TextView observin

    private func observeTextView() {
        let textView = noteTextView!
        textView.delegate = self
    }

    private func onTextViewChange(_ textView: UITextView) {
        RealmService.shared.update {
            model?.text = textView.text
        }

        if textView.frame.height < textView.intrinsicContentSize.height {
            interactionDelegate?.shouldInvalidateLayout()
        }
    }

    // MARK: - Internal

    private func updateView(with model: TaskModel) {
        noteTitleLabel.text = "Some title"
        noteTextView.text = model.text
        headerView.backgroundColor = model.isImportant ? .red : .green
    }

    // MARK: - Actions

    @IBAction func greenBtn(_ sender: UIButton) { // Actually a red btn
        headerView.backgroundColor = UIColor.rgb(59, 198, 81)
    }

    @IBAction func watchBtnTap(_ sender: UIButton) {
        interactionDelegate?.didTapAddButton()
    }
}

extension CardCollectionViewCell: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        onTextViewChange(textView)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        onTextViewChange(textView)
    }
}
