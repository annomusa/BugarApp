//
//  CustomTransition.swift
//  Bugar
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import UIKit

protocol Snapshotable {
    func getSnapshot() -> UIView 
}

class CustomTransition: NSObject,
                        UIViewControllerAnimatedTransitioning {
    
    private let animatedInitialView: UIView
    private let photo: Photo
    
    init(initialView: UIView, photo: Photo) {
        self.animatedInitialView = initialView
        self.photo = photo
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view,
              let toView = transitionContext.viewController(forKey: .to)?.view,
              let snapshotView = (animatedInitialView as? Snapshotable)?.getSnapshot()
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        containerView.addSubview(snapshotView)
        
        toView.alpha = 0
        
        let leftUpperPoint = animatedInitialView.convert(CGPoint.zero, to: nil)
        snapshotView.setXAndYFrom(leftUpperPoint)
        
        func calculateToViewSize() -> CGSize {
            let ratio: CGFloat = CGFloat(photo.height) / CGFloat(photo.width)
            let width: CGFloat = toView.width
            let height: CGFloat = width * ratio
            return CGSize(width: toView.width, height: height)
        }
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                let toViewSize = calculateToViewSize()
                let animatedViewScaleX: CGFloat = toViewSize.width / snapshotView.width
                let animatedViewScaleY: CGFloat = toViewSize.height / snapshotView.height
                snapshotView.transform = CGAffineTransform(scaleX: animatedViewScaleX, y: animatedViewScaleY)
                snapshotView.setSizeFrom(snapshotView.frame.size)
                snapshotView.center(with: toView)
                toView.alpha = 1
            },
            completion: { isFinished in
                guard isFinished else { return }
                
                snapshotView.removeFromSuperview()
                fromView.transform = .identity
                transitionContext.completeTransition(true)
            }
        )
    }
    
}
