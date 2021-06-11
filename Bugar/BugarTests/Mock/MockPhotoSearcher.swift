//
//  MockPhotoSearcher.swift
//  BugarTests
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
@testable import Bugar

final class MockPhotoSearcher: PhotosSearcher {
    
    var mockResult: Result<SearchPhotosResult, Error>?
    
    func search(
        query: String,
        page: Int,
        perPage: Int,
        onComplete: @escaping (Result<SearchPhotosResult, Error>) -> ()
    ) {
        if let mock = mockResult {
            onComplete(mock)
        }
    }
}
