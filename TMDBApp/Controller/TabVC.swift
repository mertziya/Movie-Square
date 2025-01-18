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
        
        let movieSearchVC = SearchVC()
        let searchNav = UINavigationController(rootViewController: movieSearchVC)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let accountVC = BookmarkVC()
        let accountVCNav = UINavigationController(rootViewController: accountVC)
        accountVCNav.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), tag: 2)
        accountVCNav.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        
        
        
        self.viewControllers = [homeScreenNav , searchNav, accountVCNav]
        self.tabBar.tintColor = .systemYellow
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .systemBackground.withAlphaComponent(0.85)
        
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
    }
    
}
