//
//  ImageURL.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 30/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

struct ValuesURL: Codable {
    var getSize: [Size] = []
}

struct ImageURL: Codable {
    let sizes: Sizes
    let stat: String
}

struct Sizes: Codable {
    let canblog, canprint, candownload: Int
    let size: [Size]
}

struct Size: Codable {
    let label: String
    let width, height: Height
    let source: String
    let url: String
    let media: Media
}

enum Height: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Height.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Height"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

enum Media: String, Codable {
    case photo = "photo"
}
