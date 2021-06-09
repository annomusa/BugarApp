//
//  RequestTests.swift
//  BugarTests
//
//  Created by Anno Musa on 09/06/21.
//

import Foundation
import XCTest
@testable import Bugar

final class RequestTests: XCTestCase {
    
    func test_Request_emptyQuery() {
        let url = URL(string: "https://api.unsplash.com/")!
        let sut: Request<ModelDecodable> = Request(url: url, method: .get, query: [:])
        XCTAssertEqual(url, sut.request.url)
    }
    
    func test_Request_containsOneQuery() {
        let url = URL(string: "https://api.unsplash.com/photos/search")!
        let sut: Request<ModelDecodable> = Request(url: url, method: .get, query: ["foo": "bar"])
        let expectedURL = URL(string: "https://api.unsplash.com/photos/search?foo=bar")
        XCTAssertEqual(expectedURL, sut.request.url)
    }
}
