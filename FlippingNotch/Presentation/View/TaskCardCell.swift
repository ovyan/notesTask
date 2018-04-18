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

public final class TaskCardCell: UICollectionViewCell {
    // MARK: - Outlets

    @IBOutlet var headerView: UIView!

    @IBOutlet var noteTextView: UITextView!

    @IBOutlet var noteTimeLeftLabel: UILabel!

    // MARK: - Overrides

    public override func awakeFromNib() {
        super.awakeFromNib()

        observeTextView()
    }

    public override var intrinsicContentSize: CGSize {
        let textViewHeight = noteTextView.intrinsicContentSize.height.leftBound(to: CUI.Feed.Card.textViewHeight)
        let baseWidth = frame.width

        return CGSize(width: baseWidth, height: CUI.Feed.Card.baseHeight + textViewHeight)
    }

    // MARK: - Members

    public weak var interactionDelegate: NoteInteractionDelegate?

    private var oldFrameSize: CGSize?

    private var oldText: String?

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
        let newText = textView.text
        if oldText != newText {
            updateModel()
        }

        let newSize = intrinsicContentSize
        if oldFrameSize != newSize {
            interactionDelegate?.shouldInvalidateLayout()
        }

        oldText = newText
        oldFrameSize = newSize
    }

    // MARK: - Internal

    private func updateView(with model: TaskModel) {
        // noteTitleLabel.text = "Some title"
        noteTextView.text = model.text
        headerView.backgroundColor = model.isImportant ? .red : .white
    }

    private func updateModel() {
        let text: String = noteTextView.text

        RealmService.shared.perform { [model = model!] in
            model.text = text
        }
    }

    // MARK: - Actions

    @IBAction func greenBtn(_ sender: UIButton) { // Actually a red btn
        headerView.backgroundColor = UIColor.rgb(217, 56, 41)
    }

    @IBAction func watchBtnTap(_ sender: UIButton) {
        interactionDelegate?.didTapAddButton()
    }
}

extension TaskCardCell: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        onTextViewChange(textView)
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        // onTextViewChange(textView)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        onTextViewChange(textView)
    }
}
