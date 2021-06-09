//
//  MainTabViewController.swift
//  Boogar
//
//  Created by Anno Musa on 29/03/21.
//

import UIKit
import AsyncDisplayKit

final class MainTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        
        setupVCs()
    }
    
    private func setupVCs() {
        viewControllers = [
            
        ]
    }
}
