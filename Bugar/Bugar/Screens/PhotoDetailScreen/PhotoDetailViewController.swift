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
        self.view.addSubview(photoDetailView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        photoDetailView?.showImage()
    }
}
