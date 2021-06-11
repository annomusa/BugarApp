//
//  SearchPhotosService.swift
//  Bugar
//
//  Created by Anno Musa on 10/06/21.
//

import Foundation

protocol PhotosSearcher {
    func search(
        query: String,
        page: Int,
        perPage: Int,
        onComplete: @escaping (Result<SearchPhotosResult, Error>) -> ()
    )
}

final class SearchPhotosService: PhotosSearcher {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func search(
        query: String,
        page: Int,
        perPage: Int,
        onComplete: @escaping (Result<SearchPhotosResult, Error>) -> ()
    ) {
        let request = Request<SearchPhotosResult>(
            url: Constants.UnsplashURLs.searchEndpoint,
            method: .get,
            query: [
                Constants.UnsplashQuery.query: query,
                Constants.UnsplashQuery.page: "\(page)",
                Constants.UnsplashQuery.perPage: "\(perPage)",
                Constants.UnsplashQuery.consumerKey: Constants.UnsplashBase.unsplashKey
            ]
        )
        
        urlSession.call(request: request, onComplete: onComplete)
    }
    
}
