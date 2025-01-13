//
//  DiscoverVC.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import Foundation
import UIKit

class DiscoverVC : UIViewController{
    
    let discoverView = DiscoverView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = discoverView
    }
    
    
}
