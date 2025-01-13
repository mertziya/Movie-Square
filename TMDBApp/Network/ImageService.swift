//
//  ImageService.swift
//  TMDBApp
//
//  Created by Mert Ziya on 13.01.2025.
//

import Foundation
import UIKit

class ImageService{
    
    static func fetchImage(posterPath:String , completion : @escaping (UIImage?) -> ()){
        
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else{
            print("Image URL Error")
            completion(nil)
            return
        }
        
        let request = URLRequest(url: imageURL)
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, _, error in
            if let _ = error{
                print("Image Fetching Error")
                completion(nil)
                return
            }else if let data = data {
                let poster = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(poster)
                }
            }
        }.resume()
        
        
    }
    
}
