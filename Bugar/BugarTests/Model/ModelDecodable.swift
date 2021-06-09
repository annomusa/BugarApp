//
//  ModelDecodable.swift
//  BugarTests
//
//  Created by Anno Musa on 09/06/21.
//

import Foundation

struct ModelDecodable: Decodable, Equatable {
    var attribute1: String
}

let exampleJSON = """
{
    "attribute1": "attribute_value_1"
}
"""
