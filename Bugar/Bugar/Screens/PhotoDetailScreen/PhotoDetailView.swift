//
//  PhotoDetailView.swift
//  Bugar
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import UIKit
import BlurHash

protocol PhotoDetailViewDelegate: AnyObject {
    func photoDetailOnTap()
}

final class PhotoDetailView: UIView {
    
    private let photo: Photo
    private var imageView: UIImageView = UIImageView()
    
    weak var delegate: PhotoDetailViewDelegate?
    
    init(photo: Photo) {
        self.photo = photo
        
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        addSubview(imageView)
        
        isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        
        let viewTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onTap(_:))
        )
        let imageTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onTap(_:))
        )
        addGestureRecognizer(viewTapGestureRecognizer)
        imageView.addGestureRecognizer(imageTapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let ratio: CGFloat = CGFloat(photo.height) / CGFloat(photo.width)
        var imageWidth: CGFloat = frame.width
        var imageHeight: CGFloat = ratio * frame.width
        if imageHeight > frame.height {
            let newRatio = CGFloat(photo.width) / CGFloat(photo.height)
            imageHeight = frame.height
            imageWidth = newRatio * frame.height
        }
        
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.setW(imageWidth, andH: imageHeight)
        imageView.center(with: self)
    }
    
    @objc func onTap(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.photoDetailOnTap()
    }
    
    func invalidateLayout(size: CGSize) {
        setSizeFrom(size)
        
        let ratio: CGFloat = CGFloat(photo.height) / CGFloat(photo.width)
        var imageWidth: CGFloat = frame.width
        var imageHeight: CGFloat = ratio * frame.width
        if imageHeight > frame.height {
            let newRatio = CGFloat(photo.width) / CGFloat(photo.height)
            imageHeight = frame.height
            imageWidth = newRatio * frame.height
        }
        
        imageView.setW(imageWidth, andH: imageHeight)
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
            with: URL(string: photo.urls.full),
            placeholderImage: placeholder,
            progress: { receivedSize, expectedSize, _ in
                print(receivedSize, expectedSize)
            },
            completed: { image, error, cacheType, imageURL in
                print(cacheType.rawValue)
            }
        )
    }
}
