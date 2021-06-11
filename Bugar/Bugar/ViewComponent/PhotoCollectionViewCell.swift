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
    var imageURL: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(image)
        image.clipsToBounds = true
    }
    
    func setImage(url: URL?) {
        self.imageURL = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        image.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        image.contentMode = .scaleAspectFill
        image.sd_setImage(with: imageURL, completed: nil)
    }
}
