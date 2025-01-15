//
//  MovieService.swift
//  TMDBApp
//
//  Created by Mert Ziya on 15.01.2025.
//

import Foundation

class MovieService{
    
    static func fetchMovies(title: Title , page: Int, completion: @escaping (Result<[Movie],Error>) -> ()){
        
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
    
    
    static func fetchMovieGenres(completion: @escaping (Result<[Genre],Error>) -> ()){
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(GetAPI.apiKey)") else{
            completion(.failure(ErrorTypes.URLError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do {
                    let container = try JSONDecoder().decode(GenreContainer.self, from: data)
                    let allGenres = container.genres
                    completion(.success(allGenres))
                }catch{
                    completion(.failure(error))
                }
            }else{
                completion(.failure(ErrorTypes.unknownError))
            }
        }.resume()
    }
    
    
    static func fetchVideoURLOfMovie(movie : Movie, completion : @escaping (Result<URL,Error>) -> () ){
        let movieID = String(describing: movie.id ?? 0)
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(GetAPI.apiKey)") else{
            completion(.failure(ErrorTypes.URLError))
            return
        }
        let request = URLRequest(url: url)
        
        
        let session = URLSession.shared
        
        
        session.dataTask(with: request) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let videoContainer = try JSONDecoder().decode(VideoContainer.self, from: data)
                    let allVideos = videoContainer.results
                    
                    for video in allVideos{
                        if video.site == "YouTube" {
                            guard let url = URL(string: "https://www.youtube.com/watch?v=\(video.key)") else {
                                completion(.failure(ErrorTypes.URLError))
                                return
                            }
                            completion(.success(url))
                            break
                        }
                    }
                }catch{
                    completion(.failure(error))
                }
            }else{
                completion(.failure(ErrorTypes.unknownError))
            }
        }.resume()
    }
    
    
}
