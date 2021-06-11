//
//  PhotoCollectionViewCell.swift
//  Bugar
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import UIKit
import SDWebImage

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    var image: UIImageView = UIImageView()
    var photo: Photo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        image.backgroundColor = .systemBackground
        
        contentView.addSubview(image)
        image.clipsToBounds = true
    }
    
    func set(photo: Photo) {
        self.photo = photo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let photo = photo else { return }
        
        let ratio: CGFloat = CGFloat(photo.width) / CGFloat(photo.height)
        let placeholderSize: CGSize = CGSize(width: frame.width, height: ratio * frame.width)
        var placeholder: UIImage?
        if let blurHash = photo.blurHash {
            placeholder = UIImage(blurHash: blurHash, size: placeholderSize)
        }
        image.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        image.contentMode = .scaleAspectFill
        image.sd_setImage(
            with: URL(string: photo.urls.small),
            placeholderImage: placeholder,
            completed: nil
        )
    }
}
