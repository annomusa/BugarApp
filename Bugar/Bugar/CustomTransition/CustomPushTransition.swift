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
    
    /// Creating Custom Push Transition
    /// - Parameters:
    ///   - sourcePhoto: /// Handling size nomalization after the image scaled to fit the cell size
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
        
        let snapshotView: UIImageView = UIImageView(image: sourceImage)
        let snapshotSize: CGSize = getSnapshotPhotoSize()
        snapshotView.setXAndYFrom(sourceFrame.origin)
        snapshotView.setW(snapshotSize.width, andH: snapshotSize.height)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.addSubview(snapshotView)
        
        toView.alpha = 0
        
        let toViewPhotoSize = getToViewPhotoSize(toView: toView)
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                let animatedViewScaleX: CGFloat = toViewPhotoSize.width / snapshotView.width
                let animatedViewScaleY: CGFloat = toViewPhotoSize.height / snapshotView.height
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
    
    private func getToViewPhotoSize(toView: UIView) -> CGSize {
        var ratio: CGFloat = CGFloat(sourcePhoto.height) / CGFloat(sourcePhoto.width)
        var width: CGFloat = toView.width
        var height: CGFloat = width * ratio
        
        if height > toView.height {
            ratio = CGFloat(sourcePhoto.width) / CGFloat(sourcePhoto.height)
            height = toView.height
            width = height * ratio
        }
        
        return CGSize(width: width, height: height)
    }
    
    private func getSnapshotPhotoSize() -> CGSize {
        let isLandscape = sourcePhoto.width > sourcePhoto.height
        var ratio: CGFloat = CGFloat(sourcePhoto.height) / CGFloat(sourcePhoto.width)
        var width: CGFloat = sourceFrame.width
        var height: CGFloat = width * ratio
        
        if !isLandscape {
            ratio = CGFloat(sourcePhoto.width) / CGFloat(sourcePhoto.height)
            height = sourceFrame.height
            width = height * ratio
        }
        
        return CGSize(width: width, height: height)
    }
    
}
