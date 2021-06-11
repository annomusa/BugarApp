//
//  PhotoListScreen.swift
//  Bugar
//
//  Created by Anno Musa on 10/06/21.
//

import Foundation
import UIKit
import SDWebImage

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
    
    override func loadView() {
        super.loadView()
        
        photoListView = PhotoListView(frame: view.frame)
        photoListView?.photoListDelegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(photoListView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotos()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { context in
            self.photoListView?.invalidateLayout(frame: self.view.frame)
        }
    }
}

private extension PhotoListViewController {
    
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
    
    private func prefetchLargeImage(photos: [Photo]) {
        SDWebImagePrefetcher.shared.prefetchURLs(
            photos.compactMap { URL(string: $0.urls.full) },
            progress: { noOfFinishedUrls, noOfTotalUrls in
                print(noOfFinishedUrls, noOfTotalUrls)
            },
            completed: { noOfFinishedUrls, noOfSkippedUrls in
                print(noOfFinishedUrls, noOfSkippedUrls)
            }
        )
    }
    
    private func onSuccessFetch(photos: [Photo]) {
        photoListView?.append(photos: photos)
//        prefetchLargeImage(photos: photos)
    }
}

extension PhotoListViewController: PhotoListViewDelegate {
    func photoListView(didSelect photo: Photo) {
        DispatchQueue.main.async {
            let vc = PhotoDetailViewController(photo: photo)
            self.navigationController?.pushViewController(
                vc,
                animated: true
            )
        }
    }
}
