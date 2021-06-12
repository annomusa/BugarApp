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
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        
        self.window = window
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
           let sourceAnimatable = fromVC as? PhotoSourceAnimatable,
           let sourceView = sourceAnimatable.sourceView,
           let photo = sourceAnimatable.photo {
            
            return CustomTransition(initialView: sourceView, photo: photo)
            
        } else if operation == .pop {
            
            return nil
            
        }
        
        return nil
    }
}
