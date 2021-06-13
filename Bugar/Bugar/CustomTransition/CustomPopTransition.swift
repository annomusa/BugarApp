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
    
    private let animatedInitialView: UIImage
    
    init(initialView: UIImage) {
        self.animatedInitialView = initialView
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(fromView)
        
        
    }
}
