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
    var isChangingPage = false
    var selectedIndexPath = IndexPath()
    
    var fetchedMovies : [[Movie]] = [[],[],[],[]]{
        didSet{
            DispatchQueue.main.async {
                if self.isChangingPage {
                    self.homeScreenView.tableView.reloadRows(at: [self.selectedIndexPath], with: .automatic)
                    self.isChangingPage = false
                }else{
                    self.homeScreenView.tableView.reloadData()
                }
            }
        }
    }
    var fetchedSeries : [[Series]] = [[],[],[],[]]{
        didSet{
            DispatchQueue.main.async {
                if self.isChangingPage {
                    self.homeScreenView.tableView.reloadRows(at: [self.selectedIndexPath], with: .automatic)
                    self.isChangingPage = false
                }else{
                    self.homeScreenView.tableView.reloadData()
                }
            }
        }
    }
    
    var theSelectedPageIndexOne = 1
    var theSelectedPageIndexTwo = 1
    var theSelectedPageIndexThree = 1
    var theSelectedPageIndexFour = 1

 
    
    // Lifecycles:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContent(indexRow: 0)

        fetchContent(indexRow: 1)

        fetchContent(indexRow: 2)

        fetchContent(indexRow: 3)

        
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
    func didChangePage(selectedPage page: Int?, selectedTitle: Title?, row: Int? , selectedHeading: String?) {
        self.isChangingPage = true
        if let row = row, let page = page{
            self.selectedIndexPath = IndexPath(row: row, section: .zero)
            switch row{
            case 0:
                self.theSelectedPageIndexOne = page
                fetchContent(indexRow: row)
            case 1:
                self.theSelectedPageIndexTwo = page
                fetchContent(indexRow: row)
            case 2:
                self.theSelectedPageIndexThree = page
                fetchContent(indexRow: row)
            case 3:
                self.theSelectedPageIndexFour = page
                fetchContent(indexRow: row)
            default:
                return
            }
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
        
    
        
        switch indexPath.row{
        case 0:
            
            if isMoviesPresenting{cell.moviesToShow = self.fetchedMovies[0] ; cell.isShowingMovies = true}
            if !isMoviesPresenting{cell.seriesToShow = self.fetchedSeries[0] ; cell.isShowingMovies = false}
            cell.selectedPage = theSelectedPageIndexOne
            cell.selectedTitle = isMoviesPresenting ? .nowPlaying : .onTheAirSeries
            cell.selectedRow = 0
            cell.sectionHeading.text = isMoviesPresenting ? "Now Playing" : "On The Air"
            cell.selectedHeadingText = isMoviesPresenting ? "Now Playing" : "On The Air"
            
        case 1:
            
            if isMoviesPresenting{cell.moviesToShow = self.fetchedMovies[1] ; cell.isShowingMovies = true}
            if !isMoviesPresenting{cell.seriesToShow = self.fetchedSeries[1] ; cell.isShowingMovies = false}
            cell.selectedPage = theSelectedPageIndexTwo
            cell.selectedTitle = isMoviesPresenting ? .popular : .airingTodaySeries
            cell.selectedRow = 1
            cell.sectionHeading.text = isMoviesPresenting ? "Popular" : "Airing Today"
            cell.selectedHeadingText = isMoviesPresenting ? "Popular" : "Airing Today"
            
        case 2:
            
            if isMoviesPresenting{cell.moviesToShow = self.fetchedMovies[2] ; cell.isShowingMovies = true}
            if !isMoviesPresenting{cell.seriesToShow = self.fetchedSeries[2] ; cell.isShowingMovies = false}
            cell.selectedPage = theSelectedPageIndexThree
            cell.selectedTitle = isMoviesPresenting ? .topRated : .topRatedSeries
            cell.selectedRow = 2
            cell.sectionHeading.text = isMoviesPresenting ? "Top Rated" : "Top Rated"
            cell.selectedHeadingText = isMoviesPresenting ? "Top Rated" : "Top Rated"
            
        case 3:
            
            if isMoviesPresenting{cell.moviesToShow = self.fetchedMovies[3] ; cell.isShowingMovies = true}
            if !isMoviesPresenting{cell.seriesToShow = self.fetchedSeries[3] ; cell.isShowingMovies = false}
            cell.selectedPage = theSelectedPageIndexFour
            cell.selectedTitle = isMoviesPresenting ? .upcoming : .popularSeries
            cell.selectedRow = 3
            cell.sectionHeading.text = isMoviesPresenting ? "Upcoming" : "Popular"
            cell.selectedHeadingText = isMoviesPresenting ? "Upcoming" : "Popular"
            
        default: return UITableViewCell()
        }
       
        return cell
    }
    
    private func fetchContent(indexRow : Int){
        var title : Title
        var pageNumber : Int
        switch indexRow{
        case 0:
            title = isMoviesPresenting ? .nowPlaying : .onTheAirSeries
            pageNumber = theSelectedPageIndexOne
        case 1:
            title = isMoviesPresenting ? .popular : .airingTodaySeries
            pageNumber = theSelectedPageIndexTwo
        case 2:
            title = isMoviesPresenting ? .topRated : .topRatedSeries
            pageNumber = theSelectedPageIndexThree
        case 3:
            title = isMoviesPresenting ? .upcoming : .popularSeries
            pageNumber = theSelectedPageIndexFour
        default:
            return
        }
        if isMoviesPresenting{
            MovieService.fetchMovies(title: title, page: pageNumber) { result in
                switch result{
                case .failure(let error):       print(error.localizedDescription)
                case .success(let movies):      self.fetchedMovies[indexRow] = movies;
                }
            }
        }else{
            TVService.fetchSeries(title: title, page: pageNumber) { result in
                switch result{
                case .failure(let error): print(error.localizedDescription)
                case .success(let series): self.fetchedSeries[indexRow] = series
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
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
                
                self.theSelectedPageIndexOne = 1
                self.theSelectedPageIndexTwo = 1
                self.theSelectedPageIndexThree = 1
                self.theSelectedPageIndexFour = 1
                
                self.fetchContent(indexRow: 0)
                self.fetchContent(indexRow: 1)
                self.fetchContent(indexRow: 2)
                self.fetchContent(indexRow: 3)
                
                self.homeScreenView.tableView.contentOffset = CGPoint(x: 0, y: -100) // When the user selects changes the type of content from the navbar it resets the scrolling offset of the tableView
                
            }
        }
        let action2 = UIAction(title: "TV Series") { _ in
            if self.isMoviesPresenting{
                button.setTitle("  Series", for: .normal)
                self.isMoviesPresenting = false
                
                self.theSelectedPageIndexOne = 1
                self.theSelectedPageIndexTwo = 1
                self.theSelectedPageIndexThree = 1
                self.theSelectedPageIndexFour = 1
                
                self.fetchContent(indexRow: 0)
                self.fetchContent(indexRow: 1)
                self.fetchContent(indexRow: 2)
                self.fetchContent(indexRow: 3)
                
                print(self.fetchedSeries[0].count)
               
                self.homeScreenView.tableView.contentOffset = CGPoint(x: 0, y: -100) // When the user selects changes the type of content from the navbar it resets the scrolling offset of the tableView
                
            }
        }
        let menu = UIMenu(children: [action1, action2])
        
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
}
