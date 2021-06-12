//
//  PhotoDetailViewController.swift
//  Bugar
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import UIKit

final class PhotoDetailViewController: UIViewController {
    
    private var photoDetailView: PhotoDetailView?
    private let photo: Photo
    
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
        
        photoDetailView = PhotoDetailView(photo: photo)
        photoDetailView?.frame = view.frame
        photoDetailView?.delegate = self
        self.view.addSubview(photoDetailView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        photoDetailView?.showImage()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        photoDetailView?.invalidateLayout(size: size)
    }
    
    override var prefersStatusBarHidden: Bool {
        showImageOnly
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        .slide
    }
}

extension PhotoDetailViewController: PhotoDetailViewDelegate {
    func photoDetailOnTap() {
        showImageOnly = !showImageOnly
        setNeedsStatusBarAppearanceUpdate()
        
        if showImageOnly {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
