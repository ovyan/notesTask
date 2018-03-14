//
//  UIView+Animate.swift
//  FlippingNotch
//
//  Created by Evgeniy on 15.03.18.
//  Copyright © 2018 own2pwn. All rights reserved.
//

import UIKit

public final class Animator {
    
    /// Shared Instance
    public static let shared = Animator()
    
    /// Base Animation Duration
    public var duration: TimeInterval = 0.3
    
    /// Base Delay Before Animation Starts
    public var delay: TimeInterval = 0
    
    /// Zoom transformation
    public var zoomTransform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    
    /// Base Animation Options
    /// Default to `.curveEaseInOut`
    public var options: UIViewAnimationOptions = [.curveEaseInOut]
    
    // MARK: - Animations
    
    private init() {}
}

public extension Animator {
    public func fadeIn(_ views: [UIView]) {
        // UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: { self.restoreIdentity($0, reset) })
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { self.fadeIn(views: views) }, completion: nil)
    }
    
    public func fadeInZoomIn(fade: [UIView], zoom: [UIView]) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { self.fadeInZoomIn(fade, zoom) }, completion: { self.restoreIdentity($0, reset: zoom) })
    }
}

private extension Animator {
    
    // MARK: - Fade
    
    private func fadeIn(views: [UIView]) {
        views.forEach { $0.alpha = 1 }
    }
    
    private func fadeInZoomIn(_ fade: [UIView], _ zoom: [UIView]) {
        fadeIn(fade)
        zoomIn(zoom)
    }
    
    private func zoomIn(_ views: [UIView]) {
        views.forEach { $0.transform = zoomTransform }
    }
    
    private func restoreIdentity(_ unused: Bool, reset: [UIView]) {
        reset.forEach { $0.transform = .identity }
    }
}
