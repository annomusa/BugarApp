//
//  NetworkError.swift
//  Bugar
//
//  Created by Anno Musa on 09/06/21.
//

import Foundation

struct NodataError: Error {
    init() { }
}

struct UnknownError: Error {
    init() { }
}

struct UnacceptableStatusCodeError: Error {
    let statusCode: Int
    let response: HTTPURLResponse?
    let responseBody: Data?
    init(statusCode: Int, response: HTTPURLResponse?, responseBody: Data?) {
        self.statusCode = statusCode
        self.response = response
        self.responseBody = responseBody
    }
}
