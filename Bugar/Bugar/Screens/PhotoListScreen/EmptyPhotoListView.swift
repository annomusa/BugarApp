//
//  EmptyPhotoListView.swift
//  Bugar
//
//  Created by Anno Musa on 14/06/21.
//

import Foundation
import UIKit

final class EmptyPhotoListView: NiblessView {
    
    let collectionView: UICollectionView
    
    private var emptyItem: Int
    private let collectionViewLayout: UICollectionViewFlowLayout
    private var itemsPerRow: CGFloat = 5
    private var paddingSpace: CGFloat = 1
    private var sectionInsets: UIEdgeInsets = .zero
    
    init(frame: CGRect, emptyItem: Int) {
        self.emptyItem = emptyItem
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = paddingSpace
        layout.minimumInteritemSpacing = paddingSpace
        self.collectionViewLayout = layout
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        
        super.init(frame: frame)
        
        addSubview(collectionView)
        backgroundColor = .systemBackground
        
        addSubview(collectionView)
        collectionView.frame = frame
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: photoCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.reloadData()
    }
    
    func invalidateLayout(size: CGSize) {
        self.setSizeFrom(size)
        collectionView.setSizeFrom(size)
        collectionView.layoutIfNeeded()
    }
}

extension EmptyPhotoListView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension EmptyPhotoListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emptyItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellID, for: indexPath) as? PhotoCollectionViewCell
            else { return UICollectionViewCell() }
        
        return cell
    }
}

extension EmptyPhotoListView: UICollectionViewDelegateFlowLayout {
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
