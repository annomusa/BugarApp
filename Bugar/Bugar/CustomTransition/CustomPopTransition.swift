//
//  CustomPopTransition.swift
//  Bugar
//
//  Created by Anno Musa on 13/06/21.
//

import Foundation
import UIKit

final class CustomPopTransition: NSObject,
                                 UIViewControllerAnimatedTransitioning {
    
    private let sourceImage: UIImage
    private let sourceFrame: CGRect
    
    private let transitionDuration: TimeInterval = 0.3
    
    init(sourceImage: UIImage, sourceFrame: CGRect) {
        self.sourceFrame = sourceFrame
        self.sourceImage = sourceImage
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view,
              let toView = transitionContext.viewController(forKey: .to)?.view
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let containerView = transitionContext.containerView
        
        let snapshotView = UIImageView(image: sourceImage)
        snapshotView.setX(sourceFrame.origin.x, andY: sourceFrame.origin.y)
        snapshotView.setSizeFrom(sourceFrame.size)
        snapshotView.clipsToBounds = true
        
        let startYFrame = snapshotView.frame.origin.y
        
        containerView.addSubview(snapshotView)
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        toView.alpha = 0
        
//        fromView.alpha = 1
        
        UIView.animate(
            withDuration: transitionDuration,
            animations: {
                let delta = toView.frame.origin.y - startYFrame
                snapshotView.transform = CGAffineTransform(translationX: 0, y: delta)
                snapshotView.outsideBottomEdge(of: toView, by: 0)
                toView.alpha = 1
            },
            completion: { isFinished in
                guard isFinished else { return }
                print(isFinished)
                snapshotView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        )
    }
}
