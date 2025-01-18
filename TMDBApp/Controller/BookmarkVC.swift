//
//  AccountVC.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import Foundation
import UIKit
import FirebaseAuth

class BookmarkVC : UIViewController{
    
    let barbtnButton = UIButton()
    var collectionView : UICollectionView!
    var loadingView = UIActivityIndicatorView()
    
    var isMovieSelected : Bool = true{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var hasReloadedData = true // Flag to ensure reload happens only once
    
    var bookmarkedMovies : [Movie] = []
    var bookmarkedSeries : [Series] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchbookmarkedMovies() // Initially fetches the bookmarked movies
        
        setupCollectionView()

        setupNavigation()
        
    }
    
    
    private func setupNavigation(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(logOut))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        barbtnButton.setTitle("Movies", for: .normal)
        barbtnButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        barbtnButton.tintColor = .systemYellow
        barbtnButton.setTitleColor(.label, for: .normal)
        barbtnButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        let action1 = UIAction(title: "Movies") { _ in
            self.fetchbookmarkedMovies()
        }
        let action2 = UIAction(title: "TV Series") { _ in
            self.fetchbookmarkedSeries()
        }
        let menu = UIMenu(children: [action1 , action2])
        barbtnButton.menu = menu
        barbtnButton.showsMenuAsPrimaryAction = true
        
        let barButton = UIBarButtonItem(customView: barbtnButton)
    
        navigationItem.leftBarButtonItem = barButton
        
        
        
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground.withAlphaComponent(0.85)
        navigationController?.navigationBar.standardAppearance = appearance
        
        

        if let email = Auth.auth().currentUser?.email, let username = email.split(separator: "@").first {
            navigationItem.title = String(username)
        }
        
    }
    @objc private func logOut(){
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let exitAction = UIAlertAction(title: "Exit", style: .destructive) { alert in
            do{
                try Auth.auth().signOut()
                let authVC = AuthVC()
                authVC.modalPresentationStyle = .fullScreen
                self.present(authVC, animated: true)
            }catch{
                print("ERROR")
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(exitAction)
     
        
        present(alert, animated: true)
    }
    
}


// MARK: - Setup Collection View:
extension BookmarkVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isMovieSelected ? bookmarkedMovies.count : bookmarkedSeries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailedViewCell", for: indexPath) as? DetailedViewCell else{
            print("DEBUG: Bookmark Collection View Cell Dequeue Error")
            return UICollectionViewCell()
        }
        
        setDetailedViewCell(cell: cell, index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailVC()
        vc.isMovieSelected = self.isMovieSelected
        vc.isBookmarked = true
        vc.selectedMovie = isMovieSelected ? self.bookmarkedMovies[indexPath.row] : nil
        vc.selectedSeries = !isMovieSelected ? self.bookmarkedSeries[indexPath.row] : nil
        
        vc.modalPresentationStyle = .overFullScreen
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView{
            let offsetY = scrollView.contentOffset.y
            if offsetY < -250 && hasReloadedData{
                hasReloadedData = false
                isMovieSelected ? fetchbookmarkedMovies() : fetchbookmarkedSeries()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                    self.hasReloadedData = true
                }
            }
        }
    }
    
    private func setupCollectionView(){
        
        // Collection View Layout Configurations:
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSizeMake(380, 274)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        // Collection View Configurations:
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        loadingView.hidesWhenStopped = true
        loadingView.startAnimating()
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DetailedViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailedViewCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor , constant: 0),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}


// MARK: - Network Calls:
extension BookmarkVC{
    private func fetchbookmarkedMovies(){
        loadingView.startAnimating()
        MovieService.fetchBookmarkedMovies { result in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let movies):
                self.bookmarkedMovies = movies
                self.isMovieSelected = true
                self.barbtnButton.setTitle("Movies", for: .normal)
                self.loadingView.stopAnimating()
            }
        }
    }
    
    private func fetchbookmarkedSeries(){
        loadingView.startAnimating()
        TVService.fetchBookmarkedSeries { result in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let series):
                self.bookmarkedSeries = series
                self.isMovieSelected = false
                self.barbtnButton.setTitle("TV", for: .normal)
                self.loadingView.stopAnimating()
            }
        }
    }
    
    private func setDetailedViewCell(cell : DetailedViewCell , index : Int){
        var selectedGenreNames : [String] = []
        
        
        // If movie is selected:
        if isMovieSelected{
            let bookmarkedMovie = bookmarkedMovies[index] // the Movie data for the current cell
            
            ImageService.fetchImage(posterPath: bookmarkedMovie.poster_path ?? "") { returnedImage in
                if let returnedImage = returnedImage{
                    DispatchQueue.main.async {
                        cell.contentImage.image = returnedImage
                    }
                }
            }
            MovieService.fetchMovieGenres { result in
                switch result{
                case .failure(let error): print(error.localizedDescription)
                case .success(let allGenres):
                    let selectedgenreIds = bookmarkedMovie.genre_ids ?? []
                    
                    for genre in allGenres{
                        for selectedGenre in selectedgenreIds{
                            if selectedGenre == genre.id{
                                selectedGenreNames.append(genre.name)
                            }
                        }
                    }
                    
                }
            }
            DispatchQueue.main.async {
                cell.backgroundColor = .systemBackground
                cell.contentTitle.text = bookmarkedMovie.title
                cell.descriptionLabel.text = bookmarkedMovie.overview
                cell.ratingView.rating = (bookmarkedMovie.vote_average ?? 0) / 2.0
                cell.ratingLabel.text = String(format: "%.1f", (bookmarkedMovie.vote_average ?? 0) / 2.0 )
            }
        }
        
        // If Series is selected:
        else{
            
            let bookmarkedSeries = bookmarkedSeries[index] // the Movie data for the current cell
            
            ImageService.fetchImage(posterPath: bookmarkedSeries.poster_path ?? "") { returnedImage in
                if let returnedImage = returnedImage{
                    DispatchQueue.main.async {
                        cell.contentImage.image = returnedImage
                    }
                }
            }
            MovieService.fetchMovieGenres { result in
                switch result{
                case .failure(let error): print(error.localizedDescription)
                case .success(let allGenres):
                    let selectedgenreIds = bookmarkedSeries.genre_ids ?? []
                    
                    for genre in allGenres{
                        for selectedGenre in selectedgenreIds{
                            if selectedGenre == genre.id{
                                selectedGenreNames.append(genre.name)
                            }
                        }
                    }
                    
                }
            }
            DispatchQueue.main.async {
                cell.backgroundColor = .systemBackground
                cell.contentTitle.text = bookmarkedSeries.name
                cell.descriptionLabel.text = bookmarkedSeries.overview
                cell.ratingView.rating = (bookmarkedSeries.vote_average ?? 0) / 2.0
                cell.ratingLabel.text = String(format: "%.1f", (bookmarkedSeries.vote_average ?? 0) / 2.0)
            }
            
        }
        
        // Updating the genre part is common for Movies and Series:
        DispatchQueue.main.async {
            cell.genreLabel.text = ""
            for genreName in selectedGenreNames{
                
                if selectedGenreNames.last == genreName {
                    cell.genreLabel.text! += genreName
                }else{
                    cell.genreLabel.text! += "\(genreName) / "
                }
            }
        }
        
    }
}
