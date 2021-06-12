//
//  ImageScrollView.swift
//  Beauty
//
//  Created by Nguyen Cong Huy on 1/19/16.
//  Copyright © 2016 Nguyen Cong Huy. All rights reserved.
//

import UIKit

protocol ImageScrollViewDelegate: AnyObject {
    func imageScrollViewOnTap()
}

class ImageScrollView: UIScrollView {
    
    enum ScaleMode: Int {
        case aspectFill
        case aspectFit
        case widthFill
        case heightFill
    }
    
    enum Offset: Int {
        case begining
        case center
    }
    
    let zoomInScaleDoubleTap: CGFloat = 2
    
    var imageContentMode: ScaleMode = .widthFill
    var initialOffset: Offset = .center
    
    weak var imageScrollViewDelegate: ImageScrollViewDelegate?
    
    private let photo: Photo
    private var zoomView: UIImageView? = nil
    private var imageSize: CGSize = CGSize.zero
    private var pointToCenterAfterResize: CGPoint = CGPoint.zero
    private var scaleToRestoreAfterResize: CGFloat = 1.0
    private var maxScaleFromMinScale: CGFloat = 3.0
    
    override var frame: CGRect {
        willSet {
            if !frame.equalTo(newValue),
               !newValue.equalTo(CGRect.zero),
               !imageSize.equalTo(CGSize.zero) {
                prepareToResize()
            }
        } didSet {
            if !frame.equalTo(oldValue),
               !frame.equalTo(CGRect.zero),
               !imageSize.equalTo(CGSize.zero) {
                recoverFromResizing()
            }
        }
    }
    
    init(photo: Photo) {
        self.photo = photo
        
        super.init(frame: .zero)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        decelerationRate = UIScrollView.DecelerationRate.fast
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustFrameToCenter() {
        
        guard let unwrappedZoomView = zoomView else {
            return
        }
        
        var frameToCenter = unwrappedZoomView.frame
        
        // center horizontally
        if frameToCenter.size.width < bounds.width {
            frameToCenter.origin.x = (bounds.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        // center vertically
        if frameToCenter.size.height < bounds.height {
            frameToCenter.origin.y = (bounds.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        unwrappedZoomView.frame = frameToCenter
    }
    
    private func prepareToResize() {
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        pointToCenterAfterResize = convert(boundsCenter, to: zoomView)
        
        scaleToRestoreAfterResize = zoomScale
        
        // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
        // allowable scale when the scale is restored.
        if scaleToRestoreAfterResize <= minimumZoomScale + CGFloat(Float.ulpOfOne) {
            scaleToRestoreAfterResize = 0
        }
    }
    
    private func recoverFromResizing() {
        setMaxMinZoomScalesForCurrentBounds()
        
        // restore zoom scale, first making sure it is within the allowable range.
        let maxZoomScale = max(minimumZoomScale, scaleToRestoreAfterResize)
        zoomScale = min(maximumZoomScale, maxZoomScale)
        
        // restore center point, first making sure it is within the allowable range.
        
        // convert our desired center point back to our own coordinate space
        let boundsCenter = convert(pointToCenterAfterResize, to: zoomView)
        
        // calculate the content offset that would yield that center point
        var offset = CGPoint(x: boundsCenter.x - bounds.size.width/2.0, y: boundsCenter.y - bounds.size.height/2.0)
        
        // restore offset, adjusted to be within the allowable range
        let maxOffset = maximumContentOffset()
        let minOffset = minimumContentOffset()
        
        var realMaxOffset = min(maxOffset.x, offset.x)
        offset.x = max(minOffset.x, realMaxOffset)
        
        realMaxOffset = min(maxOffset.y, offset.y)
        offset.y = max(minOffset.y, realMaxOffset)
        
        contentOffset = offset
    }
    
    private func maximumContentOffset() -> CGPoint {
        return CGPoint(x: contentSize.width - bounds.width,y:contentSize.height - bounds.height)
    }
    
    private func minimumContentOffset() -> CGPoint {
        return CGPoint.zero
    }
    
    // MARK: - Set up
    func setup() {
        var topSupperView = superview
        
        while topSupperView?.superview != nil {
            topSupperView = topSupperView?.superview
        }
        
        // Make sure views have already layout with precise frame
        topSupperView?.layoutIfNeeded()
    }
    
    // MARK: - Display image
    
    func display(image: UIImage) {
        
        if let zoomView = zoomView {
            zoomView.removeFromSuperview()
        }
        
        zoomView = UIImageView(image: image)
        zoomView?.isUserInteractionEnabled = true
        addSubview(zoomView!)
        
        let singleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(singleTapGestureRecognizer(_:))
        )
        singleTapGesture.numberOfTapsRequired = 1
        let doubleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(doubleTapGestureRecognizer(_:))
        )
        doubleTapGesture.numberOfTapsRequired = 2
        
        singleTapGesture.require(toFail: doubleTapGesture)
        singleTapGesture.delaysTouchesBegan = true
        doubleTapGesture.delaysTouchesBegan = true
        zoomView?.addGestureRecognizer(doubleTapGesture)
        zoomView?.addGestureRecognizer(singleTapGesture)
        
        configureImageForSize(image.size)
    }
    
    private func configureImageForSize(_ size: CGSize) {
        imageSize = size
        contentSize = imageSize
        setMaxMinZoomScalesForCurrentBounds()
        zoomScale = minimumZoomScale
        
        switch initialOffset {
        case .begining:
            contentOffset =  CGPoint.zero
        case .center:
            let xOffset = contentSize.width < bounds.width ? 0 : (contentSize.width - bounds.width)/2
            let yOffset = contentSize.height < bounds.height ? 0 : (contentSize.height - bounds.height)/2
            
            switch imageContentMode {
            case .aspectFit:
                contentOffset =  CGPoint.zero
            case .aspectFill:
                contentOffset = CGPoint(x: xOffset, y: yOffset)
            case .heightFill:
                contentOffset = CGPoint(x: xOffset, y: 0)
            case .widthFill:
                contentOffset = CGPoint(x: 0, y: yOffset)
            }
        }
    }
    
    private func setMaxMinZoomScalesForCurrentBounds() {
        // calculate min/max zoomscale
        let xScale = bounds.width / imageSize.width    // the scale needed to perfectly fit the image width-wise
        let yScale = bounds.height / imageSize.height   // the scale needed to perfectly fit the image height-wise
        
        var minScale: CGFloat = 1
        
        switch imageContentMode {
        case .aspectFill:
            minScale = max(xScale, yScale)
        case .aspectFit:
            minScale = min(xScale, yScale)
        case .widthFill:
            minScale = xScale
        case .heightFill:
            minScale = yScale
        }
        
        
        let maxScale = maxScaleFromMinScale*minScale
        
        // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
        if minScale > maxScale {
            minScale = maxScale
        }
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale * 0.999 // the multiply factor to prevent user cannot scroll page while they use this control in UIPageViewController
    }
    
    // MARK: - Gesture
    
    @objc
    private func singleTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        imageScrollViewDelegate?.imageScrollViewOnTap()
    }
    
    @objc
    private func doubleTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        // zoom out if it bigger than the scale factor after double-tap scaling. Else, zoom in
        if zoomScale >= minimumZoomScale * zoomInScaleDoubleTap - 0.01 {
            setZoomScale(minimumZoomScale, animated: false)
            contentOffset.y = 0
        } else {
            let center = gestureRecognizer.location(in: gestureRecognizer.view)
            let zoomRect = zoomRectForScale(zoomInScaleDoubleTap * minimumZoomScale, center: center)
            zoom(to: zoomRect, animated: true)
        }
    }
    
    private func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        
        // the zoom rect is in the content view's coordinates.
        // at a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
        // as the zoom scale decreases, so more content is visible, the size of the rect grows.
        zoomRect.size.height = frame.size.height / scale
        zoomRect.size.width  = frame.size.width  / scale
        
        // choose an origin so as to get the right center.
        zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0)
        zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    // MARK: - Actions
    
    func invalidateLayout(size: CGSize) {
        setSizeFrom(size)
        setZoomScale(1, animated: false)
        self.configureImageForSize(self.imageSize)
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustFrameToCenter()
    }
}
