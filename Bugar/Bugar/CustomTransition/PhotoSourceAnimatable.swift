//
//  PhotoSourceAnimatable.swift
//  Bugar
//
//  Created by Anno Musa on 13/06/21.
//

import Foundation

protocol PhotoSourceAnimatable {
    var sourceImage: UIImage? { get }
    var sourceFrame: CGRect? { get }
    var sourcePhoto: Photo? { get }
}
