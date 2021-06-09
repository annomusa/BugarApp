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
        
        testUnsplashAPI()
    }
    
    private func testUnsplashAPI() {
        let request = Request<Welcome>(
            url: Constants.UnsplashURLs.searchEndpoint,
            method: .get,
            query: [
                Constants.UnsplashQuery.query: "fitness",
                Constants.UnsplashQuery.page: "1",
                Constants.UnsplashQuery.consumerKey: Constants.UnsplashBase.unsplashKey
            ]
        )
        
        URLSession.shared.call(request: request) { result in
            switch result {
            case .success(let res):
                print(res.results.count)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func setupVCs() {
        viewControllers = [
            
        ]
    }
}
