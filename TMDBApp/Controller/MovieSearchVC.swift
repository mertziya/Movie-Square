//
//  MovieSearchVC.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import Foundation
import UIKit

class MovieSearchVC : UIViewController{
    
    var movieSearchView = MovieSearchView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = movieSearchView
    }
    
}
