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
    
    private let photos: [Photo]
    private var currentIndex: Int
    private var showImageOnly: Bool = false
    
    private var photoDetailView: PhotoDetailView?
    
    init(photos: [Photo], currentIndex: Int) {
        self.photos = photos
        self.currentIndex = currentIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
        
        photoDetailView = PhotoDetailView(frame: view.frame, photos: photos, currentIndex: currentIndex)
        photoDetailView?.delegate = self
        photoDetailView?.frame = view.frame
        view.addSubview(photoDetailView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        photoDetailView?.scrollToCurrentIndex()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        photoDetailView?.invalidateLayout(size: size)
    }
    
    override var prefersStatusBarHidden: Bool {
        return showImageOnly
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}

extension PhotoDetailViewController: PhotoDetailViewDelegate {
    func photoDetailOnTap() {
        showImageOnly = !showImageOnly
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNavigationBarHidden(showImageOnly, animated: true)
    }
    
    func photoDetailDismissed() {
        navigationController?.popViewController(animated: true)
    }
}
