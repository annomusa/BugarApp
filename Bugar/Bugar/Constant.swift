//
//  Constant.swift
//  Bugar
//
//  Created by Anno Musa on 04/06/21.
//

import Foundation

struct Constants {
    struct UnsplashBase {
        static let baseHost: String = "https://api.unsplash.com/"
        static let unsplashKey = "8nJxQMr4Jq_JjoObjfpAsKeSjQcPudLBzCM3wD-_fsE"
    }
    
    struct UnsplashURLs {
        static let hostURL: URL = URL(string: Constants.UnsplashBase.baseHost)!
        
        /// https://unsplash.com/documentation#search-photos
        static let searchEndpoint = hostURL.appendingPathComponent("search/photos")
    }
    
    struct UnsplashQuery {
        static let query: String = "query"
        static let geo: String = "geo"
        static let consumerKey: String = "client_id"
        static let page: String = "page"
        static let perPage: String = "per_page"
    }
}
