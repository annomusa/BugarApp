//
//  PhotoDetailView.swift
//  Bugar
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import UIKit
import BlurHash

final class PhotoDetailView: UIView {
    
    private let photo: Photo
    private var imageView: UIImageView = UIImageView()
    
    init(photo: Photo) {
        self.photo = photo
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let ratio: CGFloat = CGFloat(photo.height) / CGFloat(photo.width)
        let imageSize: CGSize = CGSize(width: frame.width, height: ratio * frame.width)
        
        backgroundColor = .systemBackground
        addSubview(imageView)
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.setW(imageSize.width, andH: imageSize.height)
        imageView.center(with: self)
    }
    
    func showImage() {
        let ratio: CGFloat = CGFloat(photo.height) / CGFloat(photo.width)
        let imageSize: CGSize = CGSize(width: frame.width, height: ratio * frame.width)
        
        var placeholder: UIImage?
        if let blurHash = photo.blurHash {
            placeholder = UIImage(blurHash: blurHash, size: imageSize)
        }
        
        imageView.sd_setImage(
            with: URL(string: photo.urls.small),
            placeholderImage: placeholder,
            progress: { receivedSize, expectedSize, _ in
                print(receivedSize, expectedSize)
            },
            completed: nil
        )
    }
}
