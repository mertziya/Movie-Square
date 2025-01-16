//
//  Bookmark.swift
//  TMDBApp
//
//  Created by Mert Ziya on 16.01.2025.
//

import Foundation


// MINI MODEL FOR FETCHING IDS from firestore database
struct bookmarkContainer : Decodable{
    var userid : String
    var email : String
    var bookmarkedMovies : [bookmarkModel]
    var bookmarkedSeries : [bookmarkModel]
}

struct bookmarkModel : Decodable{
    var id : Int
    var title : String
}
