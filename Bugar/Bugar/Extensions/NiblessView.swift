//
//  NiblessView.swift
//  Bugar
//
//  Created by Anno Musa on 13/06/21.
//

import Foundation
import UIKit

class NiblessView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    }
}
