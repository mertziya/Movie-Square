//
//  Series.swift
//  TMDBApp
//
//  Created by Mert Ziya on 14.01.2025.
//

import Foundation


struct SeriesContainer : Codable{

    var dates : [String:String]?
    var page : Int?
    var results : [Series]
    var total_pages : Int?
    var total_results : Int?

}


// MARK: - Series
struct Series: Codable {
    var adult : Bool?
    var backdrop_path : String?
    var genre_ids : [Int]?
    var id : Int?
    var origin_country : [String]?
    var original_language : String?
    var original_name : String?
    var overview : String?
    var popularity : Double?
    var poster_path : String?
    var first_air_date : String?
    var name : String?
    var vote_average : Double?
    var vote_count : Int
}
