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
    func photoListView(didSelect photo: Photo, cellView: UICollectionViewCell?)
}

final class PhotoListView: UIView {
    
    weak var photoListDelegate: PhotoListViewDelegate?
    
    private let collectionView: UICollectionView
    private let collectionViewLayout: UICollectionViewFlowLayout
    private var photos: [Photo] = []
    private var itemsPerRow: CGFloat = 5
    private var paddingSpace: CGFloat = 1
    private var sectionInsets: UIEdgeInsets = .zero // .init(top: 2, left: 2, bottom: 2, right: 2)
    
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
        collectionView.reloadData()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func invalidateLayout(size: CGSize) {
        self.setSizeFrom(size)
        collectionView.setSizeFrom(size)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func render() {
        let work = {
            self.collectionView.reloadData()
        }
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async {
                work()
            }
        }
    }
    
    func set(photos: [Photo]) {
        self.photos = photos
        render()
    }
    
    func append(photos: [Photo]) {
        self.photos.append(contentsOf: photos)
        render()
    }
    
}

extension PhotoListView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

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

extension PhotoListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellView = collectionView.cellForItem(at: indexPath)
        photoListDelegate?.photoListView(didSelect: photos[indexPath.row], cellView: cellView)
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
