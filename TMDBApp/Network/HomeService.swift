//
//  HomeService.swift
//  TMDBApp
//
//  Created by Mert Ziya on 13.01.2025.
//

import Foundation

enum ErrorTypes: Error{
    case URLError
    case unknownError
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

class HomeService{
    
    static let apiKey :String = {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path),
           let apiKey = keys["API_KEY"] as? String{
            return apiKey
        }
        return "ERROR API"
    }()
    
    
    
    static func fetchMovies(title: Title , page: Int, completion: @escaping (Result<[Movie],Error>) -> ()){
        
        // v3 Auth Authentication type api_key is given as a parameter.
        guard let url = URL(string: "\(title.rawValue)?api_key=\(apiKey)&page=\(page)") else{
            completion(.failure(ErrorTypes.URLError))
            return
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let container = try JSONDecoder().decode(MovieContainer.self, from: data)
                    let movies = container.results
                    completion(.success(movies))
                    
                }catch{
                    completion(.failure(error))
                }
            }else{
                completion(.failure(ErrorTypes.unknownError))
            }
        }.resume()
    }
    
    static func fetchSeries(title : Title, page: Int, completion : @escaping (Result<[Series],Error>) -> () ){
        
        // v3 Auth Authentication type api_key is given as a parameter.
        guard let url = URL(string: "\(title.rawValue)?api_key=\(apiKey)&page=\(page)") else{
            completion(.failure(ErrorTypes.URLError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let container = try JSONDecoder().decode(SeriesContainer.self, from: data)
                    let series = container.results
                    completion(.success(series))
                }catch{
                    
                }
            }else{
                completion(.failure(ErrorTypes.unknownError))
            }
        }.resume()
        
    }
    
   
    
    
    
}
