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
        
        fetchPhotos()
    }
    
    private func fetchPhotos() {
        searchService.search(
            query: "fitness",
            page: 1,
            perPage: 10,
            onComplete: { [weak self] result in
                self?.searchPhotoResult = result
            }
        )
    }
}
