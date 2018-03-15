//
//  ViewController.swift
//  FlippingNotch
//
//  Created by Joan Disho on 14.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import QuartzCore
import UIKit
// import ChameleonFramework TODO

final class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var setTimeView: UIView!
    
    @IBOutlet var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var timeScrollView: UIScrollView!
    var contentWidth:CGFloat = 0.0

    // MARK: Fileprivates
    
    fileprivate var notchView = UIView()
    fileprivate var notchViewBottomConstraint: NSLayoutConstraint!
    fileprivate var isPulling: Bool = false
    
    // MARK: Overrides
    
    private var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeScrollView.delegate = self
        
        for image in 0...5 {
            let iconSize = 100
            let imageToDisplay = UIImage(named: "\(image).png")
            let imageView = UIImageView(image: imageToDisplay)
            let xCoordinate = CGFloat(image)*CGFloat(iconSize+10)
            contentWidth += CGFloat(iconSize + 10) //timeScrollView.frame.width
            timeScrollView.addSubview(imageView)
            imageView.frame = CGRect(x: xCoordinate + 10, y: (timeScrollView.frame.height / 2) - 50, width: 100, height: 100)
        }
        
        timeScrollView.contentSize = CGSize(width: contentWidth+10, height: timeScrollView.frame.height)
        
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
    
    private var datasource = NotesMockDataProvider.notes(2) { didSet { onDatasourceChange(datasource) } }
    
    // MARK: UI
    
    private func configureNotchView() {
        view.addSubview(notchView)
        
        notchView.translatesAutoresizingMaskIntoConstraints = false
        notchView.backgroundColor = UIColor.black
        notchView.layer.cornerRadius = 20
        notchView.layer.masksToBounds = false
        
        notchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        notchView.widthAnchor.constraint(equalToConstant: Constants.notchWidth).activate()
        notchView.heightAnchor.constraint(equalToConstant: 200).activate()
        notchViewBottomConstraint = notchView.bottomAnchor.constraint(equalTo: view.topAnchor,
                                                                      constant: Constants.notchHeight)
        notchViewBottomConstraint.activate()
    }
    
    private func animateView() {
        let animatableView = UIImageView(frame: notchView.frame)
        animatableView.backgroundColor = UIColor.black
        animatableView.layer.cornerRadius = notchView.layer.cornerRadius
        animatableView.layer.masksToBounds = true
        animatableView.frame = notchView.frame
        view.addSubview(animatableView)
        
        notchViewBottomConstraint.constant = Constants.notchHeight
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let height = flowLayout.itemSize.height + flowLayout.minimumInteritemSpacing
        
        collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -Constants.maxScrollOffset)
        
        func cvAnimation() {
            let itemSize = flowLayout.itemSize
            animatableView.frame.size = CGSize(width: Constants.notchWidth,
                                               height: (itemSize.height / itemSize.width) * Constants.notchWidth)
            animatableView.image = UIImage.fromColor(view.backgroundColor?.withAlphaComponent(0.2) ?? UIColor.black)
            animatableView.frame.origin.y = Constants.notchViewTopInset
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
        let newNote = NotesMockDataProvider.note()
        datasource.insert(newNote, at: 0)
    }
    
    private func onDatasourceChange(_ newItems: [NoteViewModel]) {
        collectionView.reloadData()
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        hideModal()
    }
}

// MARK: UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return datasource.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCollectionViewCell
        cell.headerView.backgroundColor = UIColor.rgb(251, 199, 0)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.delegate = self
        
        let item = datasource[indexPath.row]
        cell.title = item.title
        cell.text = item.text
        
        return cell
    }
}

var firstItemHeight: CGFloat = 270

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
    }
}

// MARK: UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = max(Constants.maxScrollOffset, scrollView.contentOffset.y)
        notchViewBottomConstraint.constant = Constants.notchHeight - min(0, scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= Constants.maxScrollOffset {
            animateView()
        }
    }
}

extension ViewController: CardNoteDelegate {
    func didTapAddButton() {
        showModal()
    }
}
