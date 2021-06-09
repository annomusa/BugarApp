//
//  Request.swift
//  Bugar
//
//  Created by Anno Musa on 09/06/21.
//

import Foundation

struct Request<Model> {
    
    var request: URLRequest
    var parser: (Data?, URLResponse?) -> Result<Model, Error>
    
    var headers: [String: String] = [:]
    var acceptableContentType: ContentType = .json
    var requestContentType: ContentType = .json
    var successStatusCode: (Int) -> Bool = { $0 >= 200 && $0 < 300 }
    
    init(
        url: URL,
        method: HTTPMethod,
        query: [String: String],
        parser: @escaping (Data?, URLResponse?) -> Result<Model, Error>
    ) {
        var requestURL: URL
        if query.isEmpty {
            requestURL = url
        } else {
            var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            comps.queryItems = comps.queryItems ?? []
            let queryItem = query.map { URLQueryItem(name: $0.key, value: $0.value) }
            comps.queryItems!.append(contentsOf: queryItem)
            requestURL = comps.url!
        }
        
        self.request = URLRequest(url: requestURL)
        self.parser = parser
    }
}

extension Request where Model: Decodable {
    init(
        url: URL,
        method: HTTPMethod,
        query: [String: String]
    ) {
        self.init(url: url, method: method, query: query) { data, urlResponse in
            return Result {
                if let data = data {
                    let decoder = JSONDecoder()
                    return try decoder.decode(Model.self, from: data)
                } else {
                    throw NodataError()
                }
            }
        }
    }
}
