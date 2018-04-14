//
//  ViewController.swift
//  FlippingNotch
//
//  Created by Joan Disho on 14.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import QuartzCore
import RealmSwift
import UIKit
// import ChameleonFramework TODO

final class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var setTimeView: UIView!
    
    @IBOutlet var visualEffectView: UIVisualEffectView!
    
    @IBOutlet var timeScrollView: UIScrollView!
    
    @IBOutlet var popupStackView: UIStackView!
    
    // MARK: Fileprivates
    
    private var notchView = UIView()
    private var notchViewBottomConstraint: NSLayoutConstraint!
    private var isPulling: Bool = false
    
    private var effect: UIVisualEffect!
    
    private var contentWidth: CGFloat = 0.0
    
    private var firstItemHeight: CGFloat = 270
    
    // MARK: - Members
    
    private let realm = RealmService()
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    private func setupScreen() {
        setupPopupContainer()
        
        configureNotchView()
        collectionView.alwaysBounceVertical = true
    }
    
    private func setupPopupContainer() {
        visualEffectView.alpha = 0
        setTimeView.alpha = 0
        
        visualEffectView.isHidden = false
        setTimeView.isHidden = false
        
        timeScrollView.contentInset.right = 10
        setupPopupButtons()
        addPopupButtons()
    }
    
    private func setupPopupButtons() {
        let buttons = popupStackView.subviews
        buttons.forEach {
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
        }
    }
    
    private func addPopupButtons() {
        let itemFrame = CGRect(origin: .zero, size: CGSize(width: 120, height: 120))
        let itemContainer = UIView(frame: itemFrame)
        itemContainer.backgroundColor = .yellow
        let containerCenter = itemContainer.center
        
        let buttomImageView = UIImageView(frame: CGRect(origin: itemContainer.center, size: CGSize(width: 64, height: 64)))
        buttomImageView.image = #imageLiteral(resourceName: "1")
        
        // let imageLabel = UILabel.init(frame: CGRect.init(origin: CGPoint.init(x: containerCenter.x, y: 92), size: <#T##CGSize#>))
    }
    
    private func showModal() {
        visualEffectView.isHidden = false
        setTimeView.isHidden = false
        
        Animator.shared.fadeIn([visualEffectView, setTimeView])
    }
    
    private func hideModal() {
        Animator.shared.fadeOutZoomIn(fade: [visualEffectView, setTimeView], zoom: [setTimeView])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: - Members
    
    private var datasource: Results<TaskModel> {
        return realm.getAll()
    }
    
    // MARK: UI
    
    private func configureNotchView() {
        view.addSubview(notchView)
        
        notchView.translatesAutoresizingMaskIntoConstraints = false
        notchView.backgroundColor = UIColor.black
        notchView.layer.cornerRadius = 20
        notchView.layer.masksToBounds = false
        
        notchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        notchView.widthAnchor.constraint(equalToConstant: Constants.Notch.notchWidth).activate()
        notchView.heightAnchor.constraint(equalToConstant: 200).activate()
        notchViewBottomConstraint = notchView.bottomAnchor.constraint(equalTo: view.topAnchor,
                                                                      constant: Constants.Notch.notchHeight)
        notchViewBottomConstraint.activate()
    }
    
    private func animateView() {
        let animatableView = UIImageView(frame: notchView.frame)
        animatableView.backgroundColor = UIColor.black
        animatableView.layer.cornerRadius = notchView.layer.cornerRadius
        animatableView.layer.masksToBounds = true
        animatableView.frame = notchView.frame
        view.addSubview(animatableView)
        
        notchViewBottomConstraint.constant = Constants.Notch.notchHeight
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let height = flowLayout.itemSize.height + flowLayout.minimumInteritemSpacing
        
        collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -Constants.Notch.maxScrollOffset)
        
        func cvAnimation() {
            let itemSize = flowLayout.itemSize
            animatableView.frame.size = CGSize(width: Constants.Notch.notchWidth,
                                               height: (itemSize.height / itemSize.width) * Constants.Notch.notchWidth)
            animatableView.image = UIImage.fromColor(view.backgroundColor?.withAlphaComponent(0.2) ?? UIColor.black)
            animatableView.frame.origin.y = Constants.Notch.notchViewTopInset
            collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: height * 0.5)
        }
        
        func cvAnimationCompletion(_ param: Bool) {
            let item = collectionView.cellForItem(at: IndexPath(row: 0, section: 0))
            animatableView.image = item?.snapshotImage()
            
            UIView.transition(with: animatableView,
                              duration: 0.2,
                              options: UIViewAnimationOptions.transitionFlipFromBottom,
                              animations: {
                                  animatableView.frame.size = flowLayout.itemSize
                                  animatableView.frame.origin = CGPoint(x: (self.collectionView.frame.width - flowLayout.itemSize.width) / 2.0,
                                                                        y: self.collectionView.frame.origin.y - height * 0.5)
                                  self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: height)
                              },
                              completion: { _ in
                                  self.collectionView.transform = CGAffineTransform.identity
                                  animatableView.removeFromSuperview()
                                  self.isPulling = false
                                  self.appendNote()
            })
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: cvAnimation, completion: cvAnimationCompletion)
        
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.fromValue = 16
        cornerRadiusAnimation.toValue = 10
        cornerRadiusAnimation.duration = 0.3
        animatableView.layer.add(cornerRadiusAnimation, forKey: "cornerRadius")
        animatableView.layer.cornerRadius = 10
    }
    
    private func appendNote() {
        // let newNote = NotesMockDataProvider.note()
        // datasource.insert(newNote, at: 0)
        let newNote = TaskModel()
        realm.save(newNote)
        
        lastEditedModel = newNote
        collectionView.reloadData()
    }
    
    private func onDatasourceChange(_ newItems: [NoteViewModel]) {
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func doneBtn(_ sender: UIButton) {
        hideModal()
    }
    
    @IBAction func onPopupButtonTap(_ sender: UIButton) {
        let idx = abs(sender.tag) - 4
        print("did tap on \(idx)!")
    }
    
    // ===
    
    private var lastEditedModel: TaskModel?
}

// MARK: UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCollectionViewCell
        cell.headerView.backgroundColor = UIColor.rgb(251, 199, 0)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.delegate = self
        
        let item = datasource[indexPath.row]
        cell.model = item
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        lastEditedModel = cell.model
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: 360, height: firstItemHeight)
        }
        
        return CGSize(width: 360, height: 210)
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let oldFrame = textView.frame
        let newFrame = oldFrame.insetBy(dx: 0, dy: 16)
        
        firstItemHeight += 8
        collectionView.collectionViewLayout.invalidateLayout()
        
        guard let cell = textView.superview?.superview?.superview as? CardCollectionViewCell else { return }
        
        lastEditedModel = cell.model
        onTextChange(textView.text)
    }
    
    private func onTextChange(_ newText: String) {
        if let model = lastEditedModel {
            realm.write {
                model.text = newText
            }
        }
    }
}

// MARK: UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = max(Constants.Notch.maxScrollOffset, scrollView.contentOffset.y)
        notchViewBottomConstraint.constant = Constants.Notch.notchHeight - min(0, scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= Constants.Notch.maxScrollOffset {
            animateView()
        }
    }
}

extension ViewController: CardNoteDelegate {
    func didTapAddButton() {
        showModal()
    }
}
