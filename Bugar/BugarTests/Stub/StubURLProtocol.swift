//
//  StubURLProtocol.swift
//  BugarTests
//
//  Created by Anno Musa on 09/06/21.
//

import Foundation

struct StubResponse {
    let response: HTTPURLResponse
    let data: Data
}

class StubURLProcotol: URLProtocol {
    static var urls: [URL: StubResponse] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else { return false }
        return urls.keys.contains(url)
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        false
    }
    
    override func startLoading() {
        guard let client = client, let url = request.url, let stub = StubURLProcotol.urls[url] else {
            fatalError()
        }
        
        client.urlProtocol(self, didReceive: stub.response, cacheStoragePolicy: .notAllowed)
        client.urlProtocol(self, didLoad: stub.data)
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
