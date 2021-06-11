//
//  PhotoListScreen.swift
//  Bugar
//
//  Created by Anno Musa on 10/06/21.
//

import Foundation
import UIKit

final class PhotoListViewController: UIViewController {
    
    private let searchService: PhotosSearcher
    private var photoListView: PhotoListView?
    var searchPhotoResult: Result<SearchPhotosResult, Error>?
    
    init(searchService: PhotosSearcher) {
        self.searchService = searchService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoListView = PhotoListView(frame: view.frame)
        navigationController?.setNavigationBarHidden(true, animated: false)
        view = photoListView
        fetchPhotos()
    }
    
    private func fetchPhotos() {
        searchService.search(
            query: "fitness",
            page: 1,
            perPage: 20,
            onComplete: { [weak self] result in
                guard let s = self else { return }
                s.searchPhotoResult = result
                dump(result)
                switch result {
                case .success(let searchResult):
                    s.onSuccessFetch(photos: searchResult.results)
                case .failure(_):
                    break
                }
            }
        )
    }
    
    private func onSuccessFetch(photos: [Photo]) {
        photoListView?.append(photos: photos)
    }
}

extension PhotoListViewController: PhotoListViewDelegate {
    func photoListView(didSelect image: Photo) {
        
    }
}
