//
//  Protocols.swift
//  TMDBApp
//
//  Created by Mert Ziya on 15.01.2025.
//

import Foundation

protocol bookmarkDelegate : AnyObject{
    func getBookmarkedValueBool(isBookmarked: Bool) 
}
