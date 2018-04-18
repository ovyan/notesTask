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
    
    /// ZoomIn transformation
    public var zoomInTransform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    
    /// ZoomOut transformation
    public var zoomOutTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    /// Base Animation Options
    /// Default to `.curveEaseInOut`
    public var options: UIViewAnimationOptions = [.curveEaseInOut]
    
    // MARK: - Animations
    
    private init() {}
}

public extension Animator {
    // MARK: - Fade
    
    public func fadeIn(_ views: [UIView]) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { self.fadeIn(views: views) }, completion: nil)
    }
    
    public func fadeOut(_ views: [UIView]) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { self.fadeOut(views: views) }, completion: nil)
    }
    
    // MARK: - Combined
    
    public func fadeInZoomIn(fade: [UIView], zoom: [UIView]) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { self.fadeInZoomIn(fade, zoom) }, completion: { self.restoreIdentity($0, reset: zoom) })
    }
    
    public func fadeOutZoomOut(fade: [UIView], zoom: [UIView]) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { self.fadeOutZoomOut(fade, zoom) }, completion: { self.restoreIdentity($0, reset: zoom) })
    }
    
    public func fadeOutZoomIn(fade: [UIView], zoom: [UIView]) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { self.fadeOutZoomIn(fade, zoom) }, completion: { self.restoreIdentity($0, reset: zoom) })
    }
}

private extension Animator {
    
    // MARK: - Fade
    
    private func fadeIn(views: [UIView]) {
        views.forEach { $0.alpha = 1 }
    }
    
    private func fadeOut(views: [UIView]) {
        views.forEach { $0.alpha = 0 }
    }
    
    // MARK: - Zoom
    
    private func zoomIn(views: [UIView]) {
        views.forEach { $0.transform = zoomInTransform }
    }
    
    private func zoomOut(views: [UIView]) {
        views.forEach { $0.transform = zoomOutTransform }
    }
    
    // MARK: - Combined
    
    private func fadeInZoomIn(_ fade: [UIView], _ zoom: [UIView]) {
        fadeIn(views: fade)
        zoomIn(views: zoom)
    }
    
    private func fadeOutZoomOut(_ fade: [UIView], _ zoom: [UIView]) {
        fadeOut(views: fade)
        zoomOut(views: zoom)
    }
    
    private func fadeOutZoomIn(_ fade: [UIView], _ zoom: [UIView]) {
        fadeOut(views: fade)
        zoomIn(views: zoom)
    }
    
    // MARK: - Helpers
    
    private func restoreIdentity(_ unused: Bool, reset: [UIView]) {
        reset.forEach { $0.transform = .identity }
    }
}
