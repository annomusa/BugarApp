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
    var placeholder: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        image.backgroundColor = .systemBackground
        
        contentView.addSubview(image)
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
    }
    
    func set(photo: Photo) {
        self.photo = photo
        if let blurHash = photo.blurHash {
            placeholder = UIImage(blurHash: blurHash, size: frame.size)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let photo = photo else { return }
        
        image.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        image.sd_setImage(
            with: URL(string: photo.urls.thumb),
            placeholderImage: placeholder,
            completed: { _, _, cacheType, url in
                print("-- cell")
                print(cacheType.rawValue, url!.absoluteString)
            }
        )
    }
}

extension PhotoCollectionViewCell: Snapshotable {
    func getSnapshot() -> UIView {
        let snapshotView = UIImageView(image: image.image)
        
        snapshotView.frame = image.frame
        return snapshotView
    }
}
