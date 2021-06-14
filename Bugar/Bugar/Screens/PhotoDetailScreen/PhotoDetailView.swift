//
//  PhotoDetailView.swift
//  Bugar
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import UIKit
import BlurHash

let photoDetailCellID = "photoCellID"

protocol PhotoDetailViewDelegate: AnyObject {
    func photoDetailOnTap()
    func photoDetailDismissed()
}

final class PhotoDetailView: NiblessView {
    
    let collectionView: UICollectionView
    private let photos: [Photo]
    private var currentIndex: Int
    private let horizontalSpacing: CGFloat = 10
    
    weak var delegate: PhotoDetailViewDelegate?
    
    init(frame: CGRect, photos: [Photo], currentIndex: Int) {
        self.photos = photos
        self.currentIndex = currentIndex
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = horizontalSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: horizontalSpacing / 2,
            bottom: 0,
            right: horizontalSpacing / 2
        )
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoDetailCollectionViewCell.self, forCellWithReuseIdentifier: photoDetailCellID)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.allowsMultipleSelection = true
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .systemBackground
        
        super.init(frame: frame)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        
        backgroundColor = .systemBackground
        isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: -(horizontalSpacing) / 2),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: horizontalSpacing / 2),
        ])
    }
    
    func scrollToCurrentIndex() {
        collectionView.scrollToItem(
            at: IndexPath(row: currentIndex, section: 0),
            at: .centeredHorizontally,
            animated: false
        )
    }
    
    func invalidateLayout(size: CGSize) {
        setSizeFrom(size)
        collectionView.setSizeFrom(size)
        collectionView.center(with: self)
        collectionView.layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoDetailView: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: photoDetailCellID, for: indexPath
        ) as? PhotoDetailCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.delegate = self
        cell.set(photo: photos[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoDetailView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width - horizontalSpacing,
            height: collectionView.bounds.height
        )
    }
}

// MARK: - UIScrollViewDelegate
extension PhotoDetailView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}

// MARK: - PhotoDetailCollectionViewCellDelegate
extension PhotoDetailView: PhotoDetailCollectionViewCellDelegate {
    func photoViewCellDidTap(_ cell: PhotoDetailCollectionViewCell) {
        delegate?.photoDetailOnTap()
    }
    
    func photoViewCellDidSwipePop() {
        delegate?.photoDetailDismissed()
    }
}
