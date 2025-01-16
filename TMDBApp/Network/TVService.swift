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
    
    static func fetchVideoURLOfSeries(series : Series, completion : @escaping (Result<URL,Error>) -> () ){
        let seriesID = String(describing: series.id ?? 0)
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(seriesID)/videos?api_key=\(GetAPI.apiKey)") else{
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
                        if video.site == "YouTube" && video.official == true {
                            guard let url = URL(string: "https://www.youtube.com/watch?v=\(video.key)") else {
                                completion(.failure(ErrorTypes.URLError))
                                return
                            }
                            print(url.absoluteString)
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
    
    static func fetchBookmarkedSeries(completion: @escaping (Result<[Series], Error>) -> ()) {
        var returningSeries: [Series] = []
        let session = URLSession.shared
        let dispatchGroup = DispatchGroup()
        var fetchErrors: [Error] = []

        FirebaseService.shared.fetchAllBookmarkedSeriesIDS { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let bookmarkedSeriesIDs):
                // Use DispatchGroup to wait for all async tasks
                for seriesID in bookmarkedSeriesIDs {
                    dispatchGroup.enter()
                    guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(seriesID)?api_key=\(GetAPI.apiKey)") else {
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
                                let series = try JSONDecoder().decode(Series.self, from: data)
                                // Ensure thread-safe access to the array
                                DispatchQueue.main.sync {
                                    returningSeries.append(series)
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
                    if !fetchErrors.isEmpty && returningSeries.isEmpty {
                        // If there are errors and no successful movies, return failure
                        completion(.failure(fetchErrors.first!))
                    } else {
                        // Otherwise, return the successful movies
                        completion(.success(returningSeries))
                    }
                }
            }
        }
    }
    
}
