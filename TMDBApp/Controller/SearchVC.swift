//
//  MovieSearchVC.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import Foundation
import UIKit

class SearchVC : UIViewController{
    
    
    let searchBar = UITextField()
    
    var selectedIndexPath: IndexPath?
    
    var contentSlider = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var contentSelectionButton = UIButton()
    
    var contentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var loadingIndicator = UIActivityIndicatorView()
        
    var isMovieSelected = true
    
    var isSearchedContent = false
    
    var fetchedMovieContent : [Movie] = []{
        didSet{
            DispatchQueue.main.async {
                if !self.isSearchedContent {self.searchBar.text = ""} // Ensures that when user cliks a genre the text of the search bar disappears

                self.contentCollectionView.contentOffset = CGPoint(x: 0, y: 0)
                self.contentCollectionView.reloadData()
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    var fetchedSeriesContent : [Series] = []{
        didSet{
            DispatchQueue.main.async {
                if !self.isSearchedContent {self.searchBar.text = ""} // Ensures that when user cliks a genre the text of the search bar disappears

                self.contentCollectionView.contentOffset = CGPoint(x: 0, y: 0)
                self.contentCollectionView.reloadData()
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    var currentGenres : [Genre] = []{
        didSet{
            DispatchQueue.main.async {
                let title = self.isMovieSelected ? "Movies " : "Series "
                self.contentSelectionButton.setTitle( title, for: .normal)
                UIView.animate(withDuration: 0.1) {
                    self.contentSlider.contentOffset = CGPoint(x: 0, y: 0) // Returns the collection views content to its original state after fetching.
                }
                self.contentSlider.reloadData()
            }
        }
    }
    
    var genreIdsToSearch : [Int] = []{
        didSet{
            if isMovieSelected{
                MovieService.fetchMoviesWithGenreids(ids: genreIdsToSearch) { res in
                    switch res{
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let movies):
                        self.fetchedMovieContent = movies
                    }
                }
            }else{
                TVService.fetchSeriesWith(genreids: genreIdsToSearch) { res in
                    switch res{
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let series):
                        self.fetchedSeriesContent = series
                    }
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    
        fetchMovieAndGenres()
    }
 
    
    
}



// MARK: - Actions:
extension SearchVC{
    @objc private func didChangeContent(){
        genreIdsToSearch = []
        isMovieSelected = isMovieSelected ? false : true
        isMovieSelected ? fetchMovieAndGenres() : fetchSeriesAndGenres()
    }
    @objc private func hideKeyboard(){
        searchBar.text = ""
        view.endEditing(true)
    }
}



// MARK: - UI & Collection View Configurations:
extension SearchVC : UITextFieldDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == contentSlider{
            return currentGenres.count
        }else if collectionView == contentCollectionView{
            print(fetchedMovieContent.count)
            return isMovieSelected ? fetchedMovieContent.count : fetchedSeriesContent.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contentSlider{
            guard let cell = contentSlider.dequeueReusableCell(withReuseIdentifier: SliderCell.reuseID, for: indexPath) as? SliderCell else{
                print("DEQUEUE ERROR")
                return UICollectionViewCell()
            }
            
            // SET THE LABEL OF THE GENRES
            cell.label.text = currentGenres[indexPath.row].name.uppercased()
            
            // Reset the cell's state.
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) == true {
                cell.backgroundColor = .systemYellow
                cell.label.textColor = .black
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.1647058725, green: 0.1647058725, blue: 0.1647058725, alpha: 1)
                cell.label.textColor = .white
            }
            
            return cell
        }else if contentCollectionView == collectionView{
            guard let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: TallMovieCell.reuseID, for: indexPath) as? TallMovieCell else{
                return UICollectionViewCell()
            }
            
            cell.titleLabel.text = isMovieSelected
                ? fetchedMovieContent[indexPath.row].title
                : fetchedSeriesContent[indexPath.row].name
            
            let posterPath = isMovieSelected ? fetchedMovieContent[indexPath.row].poster_path : fetchedSeriesContent[indexPath.row].poster_path
            fetchAndAssignImageToCell(cell: cell, posterPath: posterPath)
            
            let rating = isMovieSelected ? ((fetchedMovieContent[indexPath.row].vote_average ?? 0)/2) : ((fetchedSeriesContent[indexPath.row].vote_average ?? 0)/2)
            cell.ratingCosmosView.rating = rating
            cell.ratingLabel.text = String(format: "%.1f", rating)
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == contentSlider{
            guard let cell = collectionView.cellForItem(at: indexPath) as? SliderCell else { return }
            cell.backgroundColor = .systemYellow // Change to the selected color
            cell.label.textColor = .black
            
            isSearchedContent = false
            genreIdsToSearch.append(currentGenres[indexPath.row].id)
        }
        else if collectionView == contentCollectionView{
            print("hellonigger")
            
            let vc = DetailVC()
            vc.isMovieSelected = self.isMovieSelected
            vc.selectedMovie = isMovieSelected ? fetchedMovieContent[indexPath.row] : nil
            vc.selectedSeries = !isMovieSelected ? fetchedSeriesContent[indexPath.row] : nil
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == contentSlider{
            guard let cell = collectionView.cellForItem(at: indexPath) as? SliderCell else { return }
            cell.backgroundColor = #colorLiteral(red: 0.1647058725, green: 0.1647058725, blue: 0.1647058725, alpha: 1) // Reset to the original color
            cell.label.textColor = .white
            
            let updatedgenres = genreIdsToSearch.filter { $0 != currentGenres[indexPath.row].id }
            genreIdsToSearch = updatedgenres
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == contentSlider{
            let text = currentGenres[indexPath.row].name.uppercased() // Replace with your actual button text source
            
            // Calculate the width needed for the text
            let buttonFont = UIFont.systemFont(ofSize: 16) // Use the same font as your button
            let textWidth = text.size(withAttributes: [.font: buttonFont]).width
            
            // return the cell size
            return CGSize(width: textWidth + 32, height: 25) // Adjust height as needed
        }
        else{
            return CGSize(width: 180, height: 360)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("searched")
        isSearchedContent = true
        if isMovieSelected{
            MovieService.fetchMovieWith(query: textField.text ?? "") { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    self.fetchedMovieContent = movies
                }
            }
        }else{
            TVService.fetchSeriesWith(query: textField.text ?? "") { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let series):
                    self.fetchedSeriesContent = series
                }
            }
        }
        textField.resignFirstResponder() // dismiss the keyboard
        return true
    }
    

    private func setupUI(){
        view.backgroundColor = .systemBackground
        
        // SEARCH BAR Configurations:
        searchBar.delegate = self
       
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [
            .font : UIFont.systemFont(ofSize: 18, weight: .medium),
        ])
        searchBar.backgroundColor = #colorLiteral(red: 0.1686274707, green: 0.1686274707, blue: 0.1686274707, alpha: 1)
        searchBar.layer.cornerRadius = 12
        searchBar.returnKeyType = .search
        
        // Add a custom left view with a padding:
        let leftIcon = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        leftIcon.contentMode = .center
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 60))
        leftIcon.frame = CGRect(x: 10, y: 0, width: 20, height: 60)
        leftPaddingView.addSubview(leftIcon)
        searchBar.leftView = leftPaddingView
        searchBar.leftViewMode = .always
        
        // Add a custom right view with padding:
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        // Create a container view for the button
        let padding: CGFloat = 16 // Adjust padding as needed
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: closeButton.intrinsicContentSize.width + padding * 2, height: closeButton.intrinsicContentSize.height + padding * 2))
        // Add the button to the container view
        closeButton.frame = CGRect(x: padding, y: padding, width: closeButton.intrinsicContentSize.width, height: closeButton.intrinsicContentSize.height)
        containerView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        

        // Set the container as the rightView of the search bar
        searchBar.rightView = containerView
        searchBar.rightViewMode = .whileEditing
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        
        
        contentSelectionButton.backgroundColor = #colorLiteral(red: 0.1647058725, green: 0.1647058725, blue: 0.1647058725, alpha: 1)
        contentSelectionButton.clipsToBounds = true
        contentSelectionButton.setTitleColor(.label, for: .normal)
        contentSelectionButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        contentSelectionButton.tintColor = .white
        contentSelectionButton.layer.cornerRadius = 16
        contentSelectionButton.semanticContentAttribute = .forceRightToLeft
        contentSelectionButton.addTarget(self, action: #selector(didChangeContent), for: .touchUpInside)
        contentSelectionButton.layer.borderWidth = 1
        contentSelectionButton.layer.borderColor = UIColor.systemYellow.cgColor
        
        
        // Layout for slider Collection View:
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        
        
        // Slider Collection View Config:
        contentSlider.collectionViewLayout = layout
        contentSlider.delegate = self
        contentSlider.dataSource = self
        contentSlider.register(SliderCell.self, forCellWithReuseIdentifier: SliderCell.reuseID)
        contentSlider.alwaysBounceHorizontal = true
        contentSlider.showsHorizontalScrollIndicator = false
        contentSlider.allowsMultipleSelection = true
        
        
        // Content Collection View Layout:
        let layoutForContent = UICollectionViewFlowLayout()
        layoutForContent.scrollDirection = .vertical
        layoutForContent.minimumLineSpacing = 50
        layoutForContent.minimumInteritemSpacing = 0
        
        // Content Collection View Config:
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.collectionViewLayout = layoutForContent
        contentCollectionView.register(UINib(nibName: "TallMovieCell", bundle: nil), forCellWithReuseIdentifier: TallMovieCell.reuseID)
        contentCollectionView.showsVerticalScrollIndicator = false
        
        
        
    }
    
    private func setupConstraints(){
        view.addSubview(searchBar)
        view.addSubview(contentSlider)
        view.addSubview(contentSelectionButton)
        view.addSubview(contentCollectionView)
        contentCollectionView.addSubview(loadingIndicator)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        contentSlider.translatesAutoresizingMaskIntoConstraints = false
        contentSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 60),
            
            contentSelectionButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 26),
            contentSelectionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4),
            contentSelectionButton.heightAnchor.constraint(equalToConstant: 32),
            contentSelectionButton.widthAnchor.constraint(equalToConstant: 100),
            
            
            contentSlider.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            contentSlider.leftAnchor.constraint(equalTo: contentSelectionButton.rightAnchor, constant: 4),
            contentSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            contentSlider.heightAnchor.constraint(equalToConstant: 52),
            
            contentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            contentCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            contentCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            contentCollectionView.topAnchor.constraint(equalTo: contentSlider.bottomAnchor, constant: 12),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: contentCollectionView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentCollectionView.centerYAnchor),
        ])
    }
    
}


// MARK: - Network Calls:
extension SearchVC{
    private func fetchMovieAndGenres(){
        // INITAL FETCH FOR THE CONTENT SLIDER:
        MovieService.fetchMovieGenres { result in
            switch result{
            case.failure(let error):
                print(error.localizedDescription)
            case .success(let genres):
                self.currentGenres = genres
            }
        }
        
        MovieService.fetchMovies(title: .popular, page: 1) { res in
            switch res{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let movies):
                self.fetchedMovieContent = movies
            }
        }
    }
    
    private func fetchSeriesAndGenres(){
        TVService.fetchSeries(title: .popularSeries, page: 1) { res in
            switch res{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let series):
                self.fetchedSeriesContent = series
            }
        }
        
        TVService.fetchTVGenres { result in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let genres):
                self.currentGenres = genres
            }
        }
    }
    
    private func fetchAndAssignImageToCell(cell: TallMovieCell , posterPath: String?){
        cell.imageView.image = .solidGray
        cell.loadingIndicator.startAnimating()
        
        guard let posterPath = posterPath else{ cell.imageView.image = .solidGray ; cell.loadingIndicator.stopAnimating() ; return}
        
        ImageService.fetchImage(posterPath: posterPath) { image in
            DispatchQueue.main.async {
                if let image = image{
                    cell.imageView.image = image
                    cell.loadingIndicator.stopAnimating()
                }else{
                    print("ERROR WHILE FETCHING IMAGE")
                }
            }
        }
    }
}
