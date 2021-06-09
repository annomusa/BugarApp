//
//  URLSession+RequestTests.swift
//  BugarTests
//
//  Created by Anno Musa on 09/06/21.
//

import Foundation
import XCTest
@testable import Bugar

final class URLSessionRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(StubURLProcotol.self)
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocol.unregisterClass(StubURLProcotol.self)
    }
    
    func testDataTaskRequest() throws {
        let url = URL(string: "https://api.unsplash.com/")!
        
        StubURLProcotol.urls[url] = StubResponse(
            response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!,
            data: exampleJSON.data(using: .utf8)!
        )
        
        let request = Request<ModelDecodable>(url: url, method: .get, query: [:])
        let expectation = self.expectation(description: "Stubbed network call")
        
        let task = URLSession.shared.call(request: request) { result in
            switch result {
            case let .success(payload):
                XCTAssertEqual(ModelDecodable(attribute1: "attribute_value_1"), payload)
                expectation.fulfill()
            case let .failure(error):
                XCTFail(String(describing: error))
            }
        }
        
        task.resume()
        
        wait(for: [expectation], timeout: 1)
    }
    
}
