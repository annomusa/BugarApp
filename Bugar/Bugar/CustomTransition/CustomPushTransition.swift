//
//  CustomTransition.swift
//  Bugar
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import UIKit

final class CustomPushTransition: NSObject,
                                  UIViewControllerAnimatedTransitioning {
    
    private let sourceImage: UIImage
    private let sourceFrame: CGRect
    private let sourcePhoto: Photo
    
    init(sourceImage: UIImage, sourceFrame: CGRect, sourcePhoto: Photo) {
        self.sourceImage = sourceImage
        self.sourceFrame = sourceFrame
        self.sourcePhoto = sourcePhoto
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        guard let toView = transitionContext.viewController(forKey: .to)?.view
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let containerView = transitionContext.containerView
        
        let snapshotView: UIImageView = UIImageView(image: sourceImage)
        let isLandscape = sourcePhoto.width > sourcePhoto.height
        let ratio: CGFloat = isLandscape ? CGFloat(sourcePhoto.width) / CGFloat(sourcePhoto.height) : CGFloat(sourcePhoto.height) / CGFloat(sourcePhoto.width)
        let snapshotWidth: CGFloat = isLandscape ? (sourceFrame.width * ratio) : sourceFrame.width
        let snapshotHeigth: CGFloat = isLandscape ? sourceFrame.height : (sourceFrame.height * ratio)
        snapshotView.setXAndYFrom(sourceFrame.origin)
        snapshotView.setW(snapshotWidth, andH: snapshotHeigth)
        
        containerView.addSubview(toView)
        containerView.addSubview(snapshotView)
        
        toView.alpha = 0
        
        let leftUpperPoint = snapshotView.convert(CGPoint.zero, to: nil)
        snapshotView.setXAndYFrom(leftUpperPoint)
        
        func calculateToViewSize() -> CGSize {
            let ratio: CGFloat = CGFloat(sourcePhoto.height) / CGFloat(sourcePhoto.width)
            let width: CGFloat = toView.width
            let height: CGFloat = width * ratio
            return CGSize(width: toView.width, height: height)
        }
        
        UIView.animate(
            withDuration: 0.3,
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
                transitionContext.completeTransition(true)
            }
        )
    }
    
}
