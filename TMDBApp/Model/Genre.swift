//
//  Genre.swift
//  TMDBApp
//
//  Created by Mert Ziya on 15.01.2025.
//

import Foundation

struct GenreContainer : Decodable {
    var genres : [Genre]
}

struct Genre : Decodable {
    var id : Int
    var name : String
}
