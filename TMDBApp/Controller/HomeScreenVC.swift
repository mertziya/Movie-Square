//
//  HomeScreenVC.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import Foundation
import UIKit


class HomeScreenVC : UIViewController, PageDelegate{
    
    // Properties:
    let homeScreenView = HomeScreenView()
    var isMoviesPresenting = true
    
 
    
    // Lifecycles:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Configuration is set here.
        setupNav()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetailsVC(_:)), name: .imageTappedNotification, object: nil)
        
        view = homeScreenView
        homeScreenView.tableView.delegate = self
        homeScreenView.tableView.dataSource = self
        homeScreenView.tableView.register(UINib(nibName: "WideMovieCellContainer", bundle: nil), forCellReuseIdentifier: "WideMovieCellContainer")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self , name: .imageTappedNotification , object: nil)
    }
    
    // Delegates:
    func didChangePage(selectedPage: Int?, selectedTitle: Title?, row: Int? , selectedHeading: String?) {
        if isMoviesPresenting{
            updateAndReloadTargetCell(title: selectedTitle!, page: selectedPage!, selectedRow: row! , sectionHeading: selectedHeading)
        }else{
            updateAndReloadTargetCellTVSeries(title: selectedTitle!, page: selectedPage!, selectedRow: row! , sectionHeading: selectedHeading)
        }
    }
    
    @objc private func showDetailsVC(_ notification : Notification){
        let vc = DetailVC()
        if let userInfo = notification.userInfo as? [String : Movie] {
            guard let movie = userInfo["data"] else{return}
            vc.selectedMovie = movie
            vc.isMovieSelected = true
        }else if let userInfo = notification.userInfo as? [String : Series]{
            guard let series = userInfo["data"] else{return}
            vc.selectedSeries = series
            vc.isMovieSelected = false
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeScreenVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // number of collection view sections inside the table view.
    }
    
    // UPLOADS THE INITAL VALUE OF THE TABLE VIEW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = homeScreenView.tableView.dequeueReusableCell(withIdentifier: "WideMovieCellContainer", for: indexPath) as? WideMovieCellContainer else{
            print("Dequeue Error")
            return UITableViewCell()
        }
        cell.delegate = self
        
        if indexPath.row == 0{
            MovieService.fetchMovies(title: .nowPlaying, page: 1) { result in
                switch result{
                case .failure(let error):       print(error.localizedDescription)
                case .success(let movies):      cell.moviesToShow = movies
                }
            }
            // For communicating between the Wide Movie Container, this part is crucial.
            cell.selectedPage = 1
            cell.selectedTitle = .nowPlaying
            cell.selectedRow = 0
            cell.sectionHeading.text = "Now Playing"
            cell.selectedHeadingText = "Now Playing"
        }
        
        if indexPath.row == 1{
            MovieService.fetchMovies(title: .popular, page: 1) { result in
                switch result{
                case .failure(let error):       print(error.localizedDescription)
                case .success(let movies):      cell.moviesToShow = movies
                }
            }
            cell.selectedPage = 1
            cell.selectedTitle = .popular
            cell.selectedRow = 1
            cell.sectionHeading.text = "Popular"
            cell.selectedHeadingText = "Popular"
        }
        
        if indexPath.row == 2{
            MovieService.fetchMovies(title: .topRated, page: 1) { result in
                switch result{
                case .failure(let error):       print(error.localizedDescription)
                case .success(let movies):
                    cell.moviesToShow = movies
                }
            }
            cell.selectedPage = 1
            cell.selectedTitle = .topRated
            cell.selectedRow = 2
            cell.sectionHeading.text = "Top Rated"
            cell.selectedHeadingText = "Top Rated"

        }
        
        if indexPath.row == 3{
            MovieService.fetchMovies(title: .upcoming, page: 1) { result in
                switch result{
                case .failure(let error):       print(error.localizedDescription)
                case .success(let movies):      cell.moviesToShow = movies;
                }
            }
            cell.selectedPage = 1
            cell.selectedTitle = .upcoming
            cell.selectedRow = 3
            cell.sectionHeading.text = "Upcoming"
            cell.selectedHeadingText = "Upcoming"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
    
    
    // UPDATES THE SELECTED ROW WITH THE GIVEN PARAMTERS OF *** MOVIES ***
    func updateAndReloadTargetCell(title: Title , page : Int , selectedRow: Int, sectionHeading : String?) {
        // Update your data source
        guard let targetCell = self.homeScreenView.tableView.cellForRow(at: IndexPath(row: selectedRow, section: 0)) as? WideMovieCellContainer else {
            return
        }
        
        targetCell.selectedRow = selectedRow
        targetCell.selectedPage = page
        targetCell.selectedTitle = title
    
        targetCell.selectedHeadingText = sectionHeading
        targetCell.sectionHeading.text = sectionHeading
        
        targetCell.isShowingMovies = true
        
        MovieService.fetchMovies(title: title, page: page) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let movies):
                targetCell.moviesToShow = movies
            }
        }
        
    }
    
    
    // UPDATES THE SELECTED ROW WITH THE GIVEN PARAMTERS OF  *** TV SERIES ***
    func updateAndReloadTargetCellTVSeries(title: Title , page : Int , selectedRow: Int, sectionHeading : String?) {
        // Update your data source
        guard let targetCell = self.homeScreenView.tableView.cellForRow(at: IndexPath(row: selectedRow, section: 0)) as? WideMovieCellContainer else {
            return
        }
        
       
        targetCell.selectedRow = selectedRow
        targetCell.selectedPage = page
        targetCell.selectedTitle = title
        
        targetCell.selectedHeadingText = sectionHeading
        targetCell.sectionHeading.text = sectionHeading
        
        targetCell.isShowingMovies = false

        
        TVService.fetchSeries(title: title, page: page) { result in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let series):
                targetCell.seriesToShow = series
            }
        }
    }

    
}






extension HomeScreenVC{
    private func setupNav(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground.withAlphaComponent(0.85)
        
        navigationController?.navigationBar.standardAppearance = appearance
        
        
        
        let button = UIButton(type: .system)
        button.setTitle("  Movies", for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.setTitleColor(.label, for: .normal)

        // Adjust font and tint color
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.tintColor = .systemYellow
        
        
        
        setupDropdown(button: button)

        // Assign the button to a UIBarButtonItem
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func setupDropdown(button : UIButton){
        let action1 = UIAction(title: "Movies") { _ in
            if !self.isMoviesPresenting{
                button.setTitle("  Movies", for: .normal)
                self.isMoviesPresenting = true
                
                self.updateAndReloadTargetCell(title: .nowPlaying, page: 1, selectedRow: 0, sectionHeading: "Now Playing")
                self.updateAndReloadTargetCell(title: .popular, page: 1, selectedRow: 1, sectionHeading: "Popular")
                self.updateAndReloadTargetCell(title: .topRated, page: 1, selectedRow: 2, sectionHeading: "Top Rated")
                self.updateAndReloadTargetCell(title: .upcoming, page: 1, selectedRow: 3, sectionHeading: "Upcoming")
                
                
            }
        }
        let action2 = UIAction(title: "TV Series") { _ in
            if self.isMoviesPresenting{
                button.setTitle("  Series", for: .normal)
                self.isMoviesPresenting = false
                
                self.updateAndReloadTargetCellTVSeries(title: .onTheAirSeries, page: 1, selectedRow: 0, sectionHeading: "On The Air")
                self.updateAndReloadTargetCellTVSeries(title: .airingTodaySeries, page: 1, selectedRow: 1, sectionHeading: "Airing Today")
                self.updateAndReloadTargetCellTVSeries(title: .topRatedSeries, page: 1, selectedRow: 2, sectionHeading: "Top Rated")
                self.updateAndReloadTargetCellTVSeries(title: .popularSeries, page: 1, selectedRow: 3, sectionHeading: "Popular")
               
                
            }
        }
        let menu = UIMenu(children: [action1, action2])
        
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
}
