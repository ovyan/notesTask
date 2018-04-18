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
    
    // MARK: - Members
    
    private let realm = RealmService.shared
    
    private let datasource: Results<TaskModel> = RealmService.shared.fetchAll()
    
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
    
    // MARK: - New note
    
    private func appendNote() {
        let newNote = TaskModel()
        realm.save(newNote)
        
        // collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
        collectionView.reloadData()
        
        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: selectNewNote)
    }
    
    private func selectNewNote() {
        guard let newCells = collectionView.visibleCells as? [TaskCardCell] else { return }
        let latestCell = newCells.sorted { $0.model!.date > $1.model!.date }.first
        latestCell?.noteTextView.becomeFirstResponder()
    }
    
    private func onDatasourceChange(_ newItems: [NoteViewModel]) {
        collectionView.reloadData()
    }
    
    @objc
    func endInteraction() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func doneBtn(_ sender: UIButton) {
        hideModal()
    }
    
    @IBAction func onPopupButtonTap(_ sender: UIButton) {
        let idx = abs(sender.tag) - 4
        print("did tap on \(idx)!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TaskCardCell
        // cell.headerView.backgroundColor = UIColor.rgb(251, 199, 0)
        cell.headerView.backgroundColor = UIColor.rgb(255, 255, 255)
        cell.layer.cornerRadius = 8 // 10
        cell.layer.masksToBounds = true
        cell.interactionDelegate = self
        
        let item = datasource.reversed()[indexPath.row]
        cell.model = item
        
        setDoneOnKeyboard(for: cell)
        
        return cell
    }
    
    private func setDoneOnKeyboard(for cell: TaskCardCell) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endInteraction))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        cell.noteTextView?.inputAccessoryView = keyboardToolbar
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TaskCardCell else {
            let margin = collectionView.layoutMargins
            
            return CGSize(width: collectionView.frame.width - margin.left - margin.right, height: CUI.Feed.Card.height)
        }
        
        return cell.intrinsicContentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TaskCardCell else { return }
        
        let size = cell.frame.size
        let newSize = cell.intrinsicContentSize
        
        if newSize != size {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

public extension CGFloat {
    
    public func leftBound(to value: CGFloat) -> CGFloat {
        return self < value ? value : self
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

extension ViewController: NoteInteractionDelegate {
    func didTapAddButton() {
        showModal()
    }
    
    func shouldInvalidateLayout() {
        // collectionView.invalidateIntrinsicContentSize()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension ViewController {
    
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
            let item = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? TaskCardCell
            item?.noteTextView.isHidden = true
            animatableView.image = item?.snapshotImage()
            item?.noteTextView.isHidden = false
            
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
}
