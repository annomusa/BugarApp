//
//  SceneDelegate.swift
//  Bugar
//
//  Created by Anno Musa on 04/06/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let service = SearchPhotosService(urlSession: URLSession.shared)
        let vc = PhotoListViewController(searchService: service)
        let navCon = UINavigationController(rootViewController: vc)
        navCon.delegate = self
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.backgroundColor = .systemBackground
        self.window?.rootViewController = navCon
        self.window?.makeKeyAndVisible()
    }
}

extension SceneDelegate: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push,
           let sourceAnimatable = (fromVC as? PhotoSourceAnimatable),
           let sourceImage = sourceAnimatable.sourceImage,
           let sourceFrame = sourceAnimatable.sourceFrame,
           let sourcePhoto = sourceAnimatable.sourcePhoto {
            
            return CustomPushTransition(sourceImage: sourceImage, sourceFrame: sourceFrame, sourcePhoto: sourcePhoto)
            
        } else if operation == .pop,
                  let sourceAnimatable = fromVC as? PhotoSourceAnimatable,
                  let sourceFrame = sourceAnimatable.sourceFrame,
                  let sourceImage = sourceAnimatable.sourceImage {
            
            return CustomPopTransition(sourceImage: sourceImage, sourceFrame: sourceFrame)
            
        }
        
        return nil
    }
}
