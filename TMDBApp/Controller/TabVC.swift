//
//  TabVC.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import Foundation
import UIKit

class TabVC : UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeScreen = HomeScreenVC()
        let homeScreenNav = UINavigationController(rootViewController: homeScreen)
        homeScreenNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        homeScreenNav.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        let discover = DiscoverVC()
        discover.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "safari"), tag: 1)
        discover.tabBarItem.selectedImage = UIImage(systemName: "safari.fill")
        
        let movieSearchVC = MovieSearchVC()
        movieSearchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        
        let accountVC = BookmarkVC()
        let accountVCNav = UINavigationController(rootViewController: accountVC)
        accountVCNav.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), tag: 3)
        accountVCNav.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        
        
        
        self.viewControllers = [homeScreenNav , discover , movieSearchVC, accountVCNav]
        self.tabBar.tintColor = .systemYellow
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .systemBackground.withAlphaComponent(0.85)
        
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
    }
    
}
