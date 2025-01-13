//
//  HomeScreenVC.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import Foundation
import UIKit



class HomeScreenVC : UIViewController{
    
    let homeScreenView = HomeScreenView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view = homeScreenView
        homeScreenView.tableView.delegate = self
        homeScreenView.tableView.dataSource = self
        homeScreenView.tableView.register(UINib(nibName: "WideMovieCellContainer", bundle: nil), forCellReuseIdentifier: "WideMovieCellContainer")
        
        
     
        
        // Navigation Bar Appearance is set here.
        setupNav()
    }
}


extension HomeScreenVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // number of collection view sections inside the table view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = homeScreenView.tableView.dequeueReusableCell(withIdentifier: "WideMovieCellContainer", for: indexPath) as? WideMovieCellContainer else{
            print("Dequeue Error")
            return UITableViewCell()
        }
        
        if indexPath.row == 0{
            HomeService.fetchMovies(title: .nowPlaying, page: 1) { result in
                switch result{
                case .failure(let error):       print(error.localizedDescription)
                case .success(let movies):      cell.moviesToShow = movies
                }
            }
            cell.sectionHeading.text = "Now Playing"
        }
        
        if indexPath.row == 1{
            HomeService.fetchMovies(title: .popular, page: 1) { result in
                switch result{
                case .failure(let error):       print(error.localizedDescription)
                case .success(let movies):      cell.moviesToShow = movies
                }
            }
            cell.sectionHeading.text = "Popular"
        }
        
        if indexPath.row == 2{
            HomeService.fetchMovies(title: .topRated, page: 1) { result in
                switch result{
                case .failure(let error):       print(error.localizedDescription)
                case .success(let movies):      cell.moviesToShow = movies
                }
            }
            cell.sectionHeading.text = "Top Rated"
        }
        
        if indexPath.row == 3{
            HomeService.fetchMovies(title: .upcoming, page: 1) { result in
                switch result{
                case .failure(let error):       print(error.localizedDescription)
                case .success(let movies):      cell.moviesToShow = movies
                }
            }
            cell.sectionHeading.text = "Upcoming"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
    
}






extension HomeScreenVC{
    private func setupNav(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
    }
}
