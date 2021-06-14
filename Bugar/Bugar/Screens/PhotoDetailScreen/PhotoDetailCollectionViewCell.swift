//
//  PhotoDetailCollectionViewCell.swift
//  Bugar
//
//  Created by Anno Musa on 13/06/21.
//

import Foundation
import UIKit

protocol PhotoDetailCollectionViewCellDelegate: AnyObject {
    func photoViewCellDidTap(_ cell: PhotoDetailCollectionViewCell)
    func photoViewCellDidSwipePop()
}

final class PhotoDetailCollectionViewCell: UICollectionViewCell {
    
    private var photo: Photo?
    weak var delegate: PhotoDetailCollectionViewCellDelegate?
    
    let imageView = UIImageView()
    private let scrollView = UIScrollView()
    
    private var transitionIsUserDriving = false
    private var scrollViewIsZoomingFast = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollView()
        setupImageView()
        imageView.image = UIImage(systemName: "photo")
        
        setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(photo: Photo) {
        imageView.image = UIImage(systemName: "photo")
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        imageView.sd_setImage(
            with: URL(string: photo.urls.regular),
            completed: { [weak self] _, _, _, _ in
                self?.setNeedsLayout()
                self?.layoutIfNeeded()
            }
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        
        guard let image = imageView.image,
            scrollView.zoomScale == scrollView.minimumZoomScale else { return }
        
        let imageSize = image.size
        let imageAspect = imageSize.height / imageSize.width
        let boundsAspect = bounds.height / bounds.width
        
        let newImageSize: CGSize
        if imageAspect > boundsAspect {
            newImageSize = CGSize(width: ceil(bounds.height / imageAspect), height: bounds.height)
        } else {
            newImageSize = CGSize(width: bounds.width, height: ceil(bounds.width * imageAspect))
        }

        imageView.frame = CGRect(origin: .zero, size: newImageSize)
        scrollView.contentSize = imageView.frame.size
        
        updateInsets()
    }
}

extension PhotoDetailCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !scrollView.isZooming, !scrollView.isZoomBouncing, !scrollViewIsZoomingFast,
            scrollView.zoomScale == scrollView.minimumZoomScale
            else { return }
        
        let translation = currentVerticalTranslation()
        if scrollView.isDragging || scrollView.isDecelerating {
            imageView.transform.ty = translation
        }
        
        guard scrollView.isDragging, !scrollView.isDecelerating else { return }
        
        if !transitionIsUserDriving && abs(translation) > 10.0 {
            transitionIsUserDriving = true
        }
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView, withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        guard transitionIsUserDriving else { return }
        transitionIsUserDriving = false
        
        if abs(currentProgress()) > 0.2 || abs(velocity.y) > 0.5 {
            targetContentOffset.pointee = scrollView.contentOffset
            scrollView.contentInset.top = -scrollView.contentOffset.y
            delegate?.photoViewCellDidSwipePop()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewIsZoomingFast = scrollView.isZooming
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewIsZoomingFast = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateInsets()
    }
}

extension PhotoDetailCollectionViewCell {
    
    // MARK: - Private Methods
    
    func setupScrollView() {
        addSubview(scrollView)
        scrollView.delegate = self
        
        scrollView.bouncesZoom = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        
        scrollView.autoresizesSubviews = false
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func setupImageView() {
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }
    
    func updateInsets() {
        let verticalInset = bounds.height > imageView.frame.height ?
            ceil((bounds.height - imageView.frame.height) / 2) : 0
        
        let horizontalInset = bounds.width > imageView.frame.width ?
            ceil((bounds.width - imageView.frame.width) / 2) : 0
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
    
    func currentVerticalTranslation() -> CGFloat {
        return -(scrollView.contentInset.top + scrollView.contentOffset.y)
    }
    
    func currentProgress() -> CGFloat {
        return currentVerticalTranslation() / scrollView.bounds.height * 2
    }
    
}

extension PhotoDetailCollectionViewCell {
    
    private func setupGesture() {
        let singleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleSingleTap(_:))
        )
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.delaysTouchesBegan = true
        
        let doubleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDoubleTap(_:))
        )
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delaysTouchesBegan = true
        
        singleTapGesture.require(toFail: doubleTapGesture)
        
        addGestureRecognizer(singleTapGesture)
        addGestureRecognizer(doubleTapGesture)
    }
    @objc
    private func handleSingleTap(_ gestureRecognizer: UIGestureRecognizer) {
        delegate?.photoViewCellDidTap(self)
    }
    
    @objc
    private func handleDoubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        if scrollView.zoomScale != scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let point = gestureRecognizer.location(in: self)
            let pointInImageView = imageView.convert(point, from: self)
            
            let size = CGSize(width: bounds.width / scrollView.maximumZoomScale,
                              height: bounds.height / scrollView.maximumZoomScale)
            
            let origin = CGPoint(x: pointInImageView.x - size.width / 2.0,
                                 y: pointInImageView.y - size.width / 2.0)
            
            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        }
    }
}
