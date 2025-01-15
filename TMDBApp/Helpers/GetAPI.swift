//
//  APIKey.swift
//  TMDBApp
//
//  Created by Mert Ziya on 15.01.2025.
//

import Foundation

class GetAPI{
    
    static let apiKey :String = {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path),
           let apiKey = keys["API_KEY"] as? String{
            return apiKey
        }
        return "ERROR API"
    }()
    
}
