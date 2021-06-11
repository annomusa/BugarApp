//
//  MainTabViewController.swift
//  Boogar
//
//  Created by Anno Musa on 29/03/21.
//

import UIKit

final class MainTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .systemBackground
        navigationController?.navigationController?.isToolbarHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupVCs()
    }
    
    private func setupVCs() {
        let service = SearchPhotosService(urlSession: URLSession.shared)
        let photoListVC = PhotoListViewController(searchService: service)
        let photoListNavCon = UINavigationController(rootViewController: photoListVC)
        photoListNavCon.view.backgroundColor = .systemBackground
        photoListNavCon.tabBarItem.title = "Photo"
        photoListNavCon.tabBarItem.image = UIImage(systemName: "photo.fill.on.rectangle.fill")
        photoListNavCon.navigationBar.prefersLargeTitles = false
        
        viewControllers = [
            photoListNavCon
        ]
    }
}
