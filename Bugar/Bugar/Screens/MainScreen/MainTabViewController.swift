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
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationController?.isToolbarHidden = true
        setupVCs()
    }
    
    private func setupVCs() {
        let service = SearchPhotosService(urlSession: URLSession.shared)
        let photoListVC = PhotoListViewController(searchService: service)
        let photoListNavCon = UINavigationController(rootViewController: photoListVC)
        photoListNavCon.tabBarItem.title = "Photo"
        photoListNavCon.tabBarItem.image = UIImage(systemName: "photo.fill.on.rectangle.fill")
        photoListNavCon.navigationBar.prefersLargeTitles = false
        
        viewControllers = [
            photoListNavCon
        ]
    }
}
