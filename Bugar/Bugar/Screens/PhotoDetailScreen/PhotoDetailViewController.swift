//
//  PhotoDetailViewController.swift
//  Bugar
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import UIKit
import SDWebImage

final class PhotoDetailViewController: NiblessViewController {
    
    private let photos: [Photo]
    private var currentIndex: Int
    private var showImageOnly: Bool = false
    
    private var photoDetailView: PhotoDetailView?
    
    init(photos: [Photo], currentIndex: Int) {
        self.photos = photos
        self.currentIndex = currentIndex
        
        super.init()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
        
        photoDetailView = PhotoDetailView(frame: view.frame, photos: photos, currentIndex: currentIndex)
        photoDetailView?.delegate = self
        photoDetailView?.frame = view.frame
        view.addSubview(photoDetailView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        photoDetailView?.scrollToCurrentIndex()
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
        navigationController?.setNavigationBarHidden(showImageOnly, animated: false)
    }
    
    func photoDetailDismissed() {
        navigationController?.popViewController(animated: true)
    }
}

extension PhotoDetailViewController: PhotoSourceAnimatable {
    var sourceImage: UIImage? {
        guard let cv = photoDetailView?.collectionView,
              let currentCell = cv.visibleCells.first as? PhotoDetailCollectionViewCell
        else { return nil }
        return currentCell.imageView.image
    }
    
    var sourceFrame: CGRect? {
        guard let cv = photoDetailView?.collectionView,
              let currentCell = cv.visibleCells.first as? PhotoDetailCollectionViewCell
        else { return nil }
        
        let res = currentCell.convert(currentCell.imageView.frame, to: cv)
        return res
    }
    
    var sourcePhoto: Photo? {
        nil
    }
}
