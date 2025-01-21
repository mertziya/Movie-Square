//
//  Enums.swift
//  TMDBApp
//
//  Created by Mert Ziya on 15.01.2025.
//

import Foundation

enum ErrorTypes: Error{
    case URLError
    case firebaseUserError
    case getMovieIDURLerror
    case responseError
    case unknownError
    case noVideoSource
}

enum Title : String{
    case nowPlaying = "https://api.themoviedb.org/3/movie/now_playing"
    case popular = "https://api.themoviedb.org/3/movie/popular"
    case topRated = "https://api.themoviedb.org/3/movie/top_rated"
    case upcoming = "https://api.themoviedb.org/3/movie/upcoming"
    
    case airingTodaySeries = "https://api.themoviedb.org/3/tv/airing_today"
    case onTheAirSeries = "https://api.themoviedb.org/3/tv/on_the_air"
    case popularSeries = "https://api.themoviedb.org/3/tv/popular"
    case topRatedSeries = "https://api.themoviedb.org/3/tv/top_rated"
}
