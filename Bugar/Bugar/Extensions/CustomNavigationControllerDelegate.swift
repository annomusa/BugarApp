//
//  CustomNavigationControllerDelegate.swift
//  Bugar
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import UIKit

final class CustomNavigationControllerDelegate: NSObject,
                                                UINavigationControllerDelegate {
    
    var animatedInitialView: UIView?
    var photo: Photo?
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push, let animatedView = animatedInitialView {
            let transition = CustomTransition()
            transition.animatedInitialView = animatedView
            transition.photo = photo
            return transition
        } else if operation == .pop {
            return nil
        }
        
        return nil
    }
    
}
