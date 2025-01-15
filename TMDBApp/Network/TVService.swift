//
//  TVService.swift
//  TMDBApp
//
//  Created by Mert Ziya on 15.01.2025.
//

import Foundation

class TVService{
    
    static func fetchSeries(title : Title, page: Int, completion : @escaping (Result<[Series],Error>) -> () ){
        
        // v3 Auth Authentication type api_key is given as a parameter.
        guard let url = URL(string: "\(title.rawValue)?api_key=\(GetAPI.apiKey)&page=\(page)") else{
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
    
    
    static func fetchTVGenres(completion: @escaping (Result<[Genre],Error>) -> ()){
        
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/tv/list?api_key=\(GetAPI.apiKey)") else{
            completion(.failure(ErrorTypes.URLError))
            return
        }
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data {
                do{
                    let container = try JSONDecoder().decode(GenreContainer.self, from: data)
                    let allTVGenres = container.genres
                    completion(.success(allTVGenres))
                }catch{
                    completion(.failure(error))
                }
            }else{
                completion(.failure(ErrorTypes.unknownError))
            }
        }.resume()
    }
    
    
}
