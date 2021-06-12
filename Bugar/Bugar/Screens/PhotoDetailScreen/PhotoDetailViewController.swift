//
//  PhotoDetailViewController.swift
//  Bugar
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import UIKit
import SDWebImage

final class PhotoDetailViewController: UIViewController {
    
    private let photo: Photo
    private var imageScrollView: ImageScrollView?
    
    private var showImageOnly: Bool = false
    
    init(photo: Photo, indexPath: IndexPath = IndexPath()) {
        self.photo = photo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
        
        imageScrollView = ImageScrollView(photo: photo)
        imageScrollView?.frame = view.frame
        imageScrollView?.imageScrollViewDelegate = self
        self.view.addSubview(imageScrollView!)
        imageScrollView?.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let image = SDImageCache.shared.imageFromCache(forKey: photo.urls.regular)
        if let img = image {
            imageScrollView?.frame = view.frame
            imageScrollView?.display(image: img)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        imageScrollView?.invalidateLayout(size: size)
    }
    
    override var prefersStatusBarHidden: Bool {
        return showImageOnly
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}

extension PhotoDetailViewController: ImageScrollViewDelegate {
    func imageScrollViewOnTap() {
        showImageOnly = !showImageOnly
        setNeedsStatusBarAppearanceUpdate()
        
        if showImageOnly {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
