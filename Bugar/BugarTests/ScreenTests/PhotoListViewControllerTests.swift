//
//  PhotoListViewControllerTests.swift
//  BugarTests
//
//  Created by Anno Musa on 11/06/21.
//

import Foundation
import XCTest
@testable import Bugar

final class PhotoListViewControllerTests: XCTestCase {
    
    var sut: PhotoListViewController!
    var mockPhotoService: MockPhotoSearcher!
    
    override func setUp() {
        super.setUp()
        
        mockPhotoService = MockPhotoSearcher()
        sut = PhotoListViewController(searchService: mockPhotoService)
    }
    
    func test_completionPhotosSearch() {
        let mockResult = SearchPhotosResult(
            total: 10,
            totalPages: 10,
            results: []
        )
        mockPhotoService.mockResult = .success(mockResult)
        
        sut.viewDidLoad()
        
        XCTAssertEqual(
            mockResult.results.count,
            try sut.searchPhotoResult?.get().results.count
        )
    }
    
}
