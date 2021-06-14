//
//  PhotoListView.swift
//  Bugar
//
//  Created by Anno Musa on 10/06/21.
//

import Foundation
import UIKit

let photoCellID = "photoCellID"

protocol PhotoListViewDelegate: AnyObject {
    func photoListViewDidSelect(image: UIImage?, frame: CGRect, selectedIndex: Int)
}

final class PhotoListView: NiblessView {
    
    // MARK: - Accessible Attributes
    let collectionView: UICollectionView
    weak var photoListDelegate: PhotoListViewDelegate?
    
    // MARK: - Private Attributes
    private let collectionViewLayout: UICollectionViewFlowLayout
    private var photos: [Photo] = []
    private var itemsPerRow: CGFloat = 5
    private var paddingSpace: CGFloat = 1
    private var sectionInsets: UIEdgeInsets = .zero
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = paddingSpace
        layout.minimumInteritemSpacing = paddingSpace
        self.collectionViewLayout = layout
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        
        addSubview(collectionView)
        collectionView.frame = frame
        collectionView.alwaysBounceVertical = true
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: photoCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func invalidateLayout(size: CGSize) {
        self.setSizeFrom(size)
        collectionView.setSizeFrom(size)
        collectionView.layoutIfNeeded()
    }
    
    func render() {
        let work = {
            self.collectionView.reloadData()
        }
        executeInMainThread {
            work()
        }
    }
    
    /// Change previous photos with new one
    /// - Parameter photos: list of new photos
    func set(photos: [Photo]) {
        self.photos = photos
        render()
    }
    
    /// Appending list photos with new ones
    /// - Parameter photos: list of new photos
    func append(photos: [Photo]) {
        self.photos.append(contentsOf: photos)
        render()
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoListView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellID, for: indexPath) as? PhotoCollectionViewCell
            else { return UICollectionViewCell() }
        cell.backgroundColor = .systemBackground
        cell.set(photo: photos[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoListView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        guard let cellView = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else { return }
        
        let cellFrame = collectionView.convert(cellView.frame, to: window)
        photoListDelegate?.photoListViewDidSelect(
            image: cellView.image.image,
            frame: cellFrame,
            selectedIndex: indexPath.row
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let totalInterItemWidth: CGFloat = (itemsPerRow - 1) * paddingSpace
        let availableWidth = collectionView.frame.width - totalInterItemWidth
        let widthPerItem = CGFloat(availableWidth / itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .zero
    }
}
