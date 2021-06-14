//
//  PhotoListScreen.swift
//  Bugar
//
//  Created by Anno Musa on 10/06/21.
//

import Foundation
import UIKit
import SDWebImage

final class PhotoListViewController: NiblessViewController {
    
    // MARK: - Dependencies
    private let searchService: PhotosSearcher
    
    // MARK: - Private Attributes
    private(set) var searchPhotoResult: Result<SearchPhotosResult, Error>?
    private var photoListView: PhotoListView?
    private var emptyListView: EmptyPhotoListView?
    private let maximumPage: Int = 2
    
    // MARK: - Snapshot for custom push transition
    private(set) var selectedImage: UIImage?
    private(set) var selectedFrame: CGRect?
    private(set) var selectedPhoto: Photo?
    
    init(searchService: PhotosSearcher) {
        self.searchService = searchService
        
        super.init()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
        title = "Fitness Inspiration"
        
        showEmptyList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.photoListView?.invalidateLayout(size: size)
    }
}

extension PhotoListViewController {
    
    private func fetchPhotos() {
        searchService.search(
            query: "fitness",
            page: 1,
            perPage: 40,
            onComplete: { [weak self] result in
                guard let s = self else { return }
                s.searchPhotoResult = result
                switch result {
                case .success(let searchResult):
                    s.onSuccessFetch(photos: searchResult.results)
                case .failure(let error):
                    s.onErrorFetch(error: error)
                }
            }
        )
    }
    
    private func prefetchLargeImage(photos: [Photo]) {
        let start = DispatchTime.now()
        SDWebImagePrefetcher.shared.prefetchURLs(
            photos.compactMap { URL(string: $0.urls.regular) },
            progress: nil,
            completed: { noOfFinishedUrls, noOfSkippedUrls in
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                print("Time: \(timeInterval) seconds")
            }
        )
    }
    
    private func onSuccessFetch(photos: [Photo]) {
        renderPhotos(photos: photos)
        prefetchLargeImage(photos: photos)
    }
    
    private func onErrorFetch(error: Error) {
        executeInMainThread { [weak self] in
            self?.renderErrorView(error: error)
        }
    }
    
    private func renderErrorView(error: Error) {
        let alertView = UIAlertController(
            title: "Something went wrong",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let refreshAction = UIAlertAction(
            title: "Refresh",
            style: .default,
            handler: { [weak alertView] _ in
                alertView?.dismiss(
                    animated: true,
                    completion: { [weak self] in
                        self?.fetchPhotos()
                    }
                )
            }
        )
        alertView.addAction(refreshAction)
        present(alertView, animated: true, completion: nil)
    }
    
    private func renderPhotos(photos: [Photo]) {
        let work = { [weak self] in
            guard let s = self else { return }
            if let photoListView = s.photoListView {
                photoListView.append(photos: photos)
            } else {
                s.photoListView = PhotoListView(frame: s.view.frame)
                s.photoListView?.photoListDelegate = s
                s.photoListView?.set(photos: photos)
                s.view.addSubview(s.photoListView!)
            }
            s.hideEmptyList()
        }
        executeInMainThread {
            work()
        }
    }
    
    private func hideEmptyList() {
        executeInMainThread { [weak self] in
            guard let s = self else { return }
            s.emptyListView?.removeFromSuperview()
            s.emptyListView = nil
        }
    }
    
    private func showEmptyList() {
        executeInMainThread { [weak self] in
            guard let s = self else { return }
            s.emptyListView?.removeFromSuperview()
            s.emptyListView = EmptyPhotoListView(frame: s.view.frame, emptyItem: 20)
            s.view.addSubview(s.emptyListView!)
        }
    }
}

extension PhotoListViewController: PhotoListViewDelegate {
    func photoListViewDidSelect(image: UIImage?, frame: CGRect, selectedIndex: Int) {
        guard let photos = try? searchPhotoResult?.get().results else {
            return
        }
        selectedPhoto = photos[selectedIndex]
        selectedImage = image
        selectedFrame = frame
        
        let vc = PhotoDetailViewController(photos: photos, currentIndex: selectedIndex)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PhotoListViewController: PhotoSourceAnimatable {
    var sourceImage: UIImage? { selectedImage }
    var sourceFrame: CGRect? { selectedFrame }
    var sourcePhoto: Photo? { selectedPhoto }
}
