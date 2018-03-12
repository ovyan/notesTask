//
//  ViewController.swift
//  FlippingNotch
//
//  Created by Joan Disho on 14.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import QuartzCore
//import ChameleonFramework TODO

class ViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet var collectionView: UICollectionView!

    // MARK: Fileprivates

    fileprivate var notchView = UIView()
    fileprivate var notchViewBottomConstraint: NSLayoutConstraint!
    fileprivate var isPulling: Bool = false
    fileprivate var numberOfItemsInSection = 1
    
    // MARK: Overrides
    
    
    //MY CODE START
    
 
    @IBAction func greenBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func yellowBtn(_ sender: UIButton) {
        //noteBackground.backgroundColor = UIColor.init(red: 253, green: 205, blue: 5, alpha: 1)
    }
    
    @IBAction func redBtn(_ sender: UIButton) {
    }
    
    //MY CODE END
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNotchView()
        self.collectionView.alwaysBounceVertical = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UI

    private func configureNotchView() {
        self.view.addSubview(notchView)
        
        notchView.translatesAutoresizingMaskIntoConstraints = false
        notchView.backgroundColor = UIColor.black
        notchView.layer.cornerRadius = 20
        notchView.layer.masksToBounds = false
        
        notchView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).activate()
        notchView.widthAnchor.constraint(equalToConstant: Constants.notchWidth).activate()
        notchView.heightAnchor.constraint(equalToConstant: 200).activate()
        notchViewBottomConstraint = notchView.bottomAnchor.constraint(equalTo: self.view.topAnchor, 
                                                                       constant: Constants.notchHeight)
        notchViewBottomConstraint.activate()
    }
    
    private func animateView() {
        let animatableView = UIImageView(frame: notchView.frame)
        animatableView.backgroundColor = UIColor.black
        animatableView.layer.cornerRadius = self.notchView.layer.cornerRadius
        animatableView.layer.masksToBounds = true
        animatableView.frame = self.notchView.frame
        self.view.addSubview(animatableView)

        notchViewBottomConstraint.constant = Constants.notchHeight
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let height = flowLayout.itemSize.height + flowLayout.minimumInteritemSpacing
        
        self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -Constants.maxScrollOffset)

        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            let itemSize = flowLayout.itemSize
            animatableView.frame.size = CGSize(width: Constants.notchWidth, 
                                               height: (itemSize.height / itemSize.width) * Constants.notchWidth)
            animatableView.image = UIImage.fromColor(self.view.backgroundColor?.withAlphaComponent(0.2) ?? UIColor.black)
            animatableView.frame.origin.y = Constants.notchViewTopInset
            self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: height * 0.5)
        }) { _ in
            let item = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0))
            animatableView.image = item?.snapshotImage()
            
            UIView.transition(with: animatableView, duration: 0.2, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
                animatableView.frame.size = flowLayout.itemSize
                animatableView.frame.origin = CGPoint(x: (self.collectionView.frame.width - flowLayout.itemSize.width) / 2.0, 
                                                      y: self.collectionView.frame.origin.y - height * 0.5)
                self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: height)
                }, completion: { _ in
                    self.collectionView.transform = CGAffineTransform.identity
                    animatableView.removeFromSuperview()
                    self.isPulling = false
                    self.numberOfItemsInSection += 1
                    self.collectionView.reloadData()
                }
            )
        }
        
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.fromValue = 16
        cornerRadiusAnimation.toValue = 10
        cornerRadiusAnimation.duration = 0.3
        animatableView.layer.add(cornerRadiusAnimation, forKey: "cornerRadius")
        animatableView.layer.cornerRadius = 10
    }
}

// MARK: UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
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
