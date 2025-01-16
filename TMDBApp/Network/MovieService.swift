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
    
    static func fetchBookmarkedMovies(completion: @escaping (Result<[Movie], Error>) -> ()) {
        var returningMovies: [Movie] = []
        let session = URLSession.shared
        let dispatchGroup = DispatchGroup()
        var fetchErrors: [Error] = []

        FirebaseService.shared.fetchAllBookmarkedMovieIDS { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let bookmarkedMovieIDs):
                // Use DispatchGroup to wait for all async tasks
                for movieID in bookmarkedMovieIDs {
                    dispatchGroup.enter()
                    guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(GetAPI.apiKey)") else {
                        fetchErrors.append(ErrorTypes.getMovieIDURLerror)
                        dispatchGroup.leave()
                        continue
                    }

                    session.dataTask(with: URLRequest(url: url)) { data, _, error in
                        defer { dispatchGroup.leave() } // Ensure dispatchGroup.leave() is always called

                        if let error = error {
                            fetchErrors.append(error)
                        } else if let data = data {
                            do {
                                let movie = try JSONDecoder().decode(Movie.self, from: data)
                                // Ensure thread-safe access to the array
                                DispatchQueue.main.sync {
                                    returningMovies.append(movie)
                                }
                            } catch {
                                fetchErrors.append(error)
                            }
                        } else {
                            fetchErrors.append(ErrorTypes.unknownError)
                        }
                    }.resume()
                }

                // Wait for all tasks to complete
                dispatchGroup.notify(queue: .main) {
                    if !fetchErrors.isEmpty && returningMovies.isEmpty {
                        // If there are errors and no successful movies, return failure
                        completion(.failure(fetchErrors.first!))
                    } else {
                        // Otherwise, return the successful movies
                        completion(.success(returningMovies))
                    }
                }
            }
        }
    }
    
    
}
