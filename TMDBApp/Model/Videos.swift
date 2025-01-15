//
//  Videos.swift
//  TMDBApp
//
//  Created by Mert Ziya on 15.01.2025.
//

import Foundation

import Foundation

// Root container
struct VideoContainer: Codable {
    let id: Int
    let results: [Video]
}

// Individual video model
struct Video: Codable {
    let iso6391: String
    let iso31661: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let id: String

    // Custom coding keys to match JSON keys
    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso_639_1"
        case iso31661 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}
