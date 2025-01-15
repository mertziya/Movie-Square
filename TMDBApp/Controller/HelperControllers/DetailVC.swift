//
//  DetailVC.swift
//  TMDBApp
//
//  Created by Mert Ziya on 14.01.2025.
//

import UIKit
import WebKit
import Cosmos

class DetailVC: UIViewController {
    // MARK: - Properties:
    var selectedMovie : Movie?
    var selectedSeries : Series?
    var isMovieSelected = true
    
    
    // MARK: - UI Elements:
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func bookmarkTapped(_ sender: UIButton) {
        print("bookmarked")
    }
    
    
    @IBOutlet weak var imageToShow: UIImageView!
    @IBOutlet weak var imageUploadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var detailsDescription: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    
    
    @IBOutlet weak var ratingValue: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var playButton: UIButton!
    
    
    // MARK: - Lifecycles:
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupConstraints() // For extra constraints made with the percantage values.
        
        setupUI() // For extra UI Configurations that couldn't be handled with XIB File
        
        setupUIData() // uploads the data that is responded to the Series or Movies model inside this class.
        
       
        
    }
    
    // Gives a gradient background to the image view.
    //Gradients *MUST BE* Set at the viewDidLayoutSubvies Part.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Set the gradient background for the iamge:
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageToShow.bounds
        gradientLayer.colors = [
            UIColor.systemBackground.withAlphaComponent(0.9).cgColor,
            UIColor.systemBackground.withAlphaComponent(0.0).cgColor,
        ]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        imageToShow.layer.mask = gradientLayer
    }


 

}

// MARK: - Advanced UI Config:
extension DetailVC{
    private func setupUI(){
        
        downloadButton.layer.cornerRadius = 8
        // Set up button for touch events
        downloadButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        downloadButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
        
        ratingView.backgroundColor = .systemBackground
        ratingView.settings.fillMode = .precise
        
        playButton.alpha = 0.35
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(openWeb))
        imageToShow.isUserInteractionEnabled = true
        imageToShow.addGestureRecognizer(imageTapGesture)
        
        
        // Removes the left bar button item of the navigation controller since another design will be used [According to the design resource]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        
        let swipeToExit = UISwipeGestureRecognizer(target: self, action: #selector(viewDidSwipteToRight(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(swipeToExit)
        
    }
    
    @objc private func buttonTouchDown(){
        downloadButton.alpha = 0.5 // Higlighted state
    }
    @objc private func buttonTouchUp(){
        downloadButton.alpha = 1.0 // Normal State
    }
    
    @objc private func viewDidSwipteToRight(_ gesture : UISwipeGestureRecognizer){
        gesture.direction = .right
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func openWeb(){
        let webVC = UIViewController()
        webVC.view.backgroundColor = .systemBackground
        
        let webView = WKWebView(frame: webVC.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webVC.view.addSubview(webView)
        
        if isMovieSelected{
            guard let selectedMovie = selectedMovie else{return}
            MovieService.fetchVideoURLOfMovie(movie: selectedMovie) { [weak self] result in
                guard let self = self else { return } // Capture self weakly
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let url):
                    DispatchQueue.main.async {
                        webView.load(URLRequest(url: url))
                        self.present(webVC,animated: true)
                    }
                }
            }
        } else{
            guard let selectedSeries = selectedSeries else{return}
            TVService.fetchVideoURLOfSeries(series: selectedSeries) { [weak self] result in
                guard let self = self else { return } // Capture self weakly
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let url):
                    DispatchQueue.main.async {
                        webView.load(URLRequest(url: url))
                        self.present(webVC, animated: true)
                    }
                }
            }
        }
        
    }
    
    private func setupUIData(){
        
        fetchBackgroundImage() // Fetches the image that is coming from the data.

        detailsDescription.text = isMovieSelected ? selectedMovie?.overview : selectedSeries?.overview
        
        let avgRating = isMovieSelected ? selectedMovie?.vote_average ?? 0 : selectedSeries?.vote_average ?? 0
        ratingValue.text = String(format: "%.1f", (avgRating / 2.0))
        
        ratingView.rating = avgRating / 2.0
        
        mainTitle.text = isMovieSelected ? selectedMovie?.title : selectedSeries?.name
        
        setupGenres()
        
    }
    
}





// MARK: - Advanced Constraints:
extension DetailVC{
    private func setupConstraints(){
        imageToShow.addSubview(imageUploadIndicator)
        
        imageUploadIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageToShow.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageUploadIndicator.centerXAnchor.constraint(equalTo: imageToShow.centerXAnchor),
            imageUploadIndicator.centerYAnchor.constraint(equalTo: imageToShow.centerYAnchor),
            
            imageToShow.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.68),
            
            playButton.centerXAnchor.constraint(equalTo: imageToShow.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: imageToShow.centerYAnchor),
            
        ])
    }
}



// MARK: - Network Calls:
extension DetailVC{
    
    // sets the background image after fetching the image is completed, assuring smooth transitioning between screens.
    private func fetchBackgroundImage(){
        guard let bgImagePath = isMovieSelected ? selectedMovie?.poster_path : selectedSeries?.poster_path else{ print("unwrap error"); return }
        ImageService.fetchImage(posterPath: bgImagePath) { poster in
            if let poster = poster{
                DispatchQueue.main.async {
                    self.imageToShow.image = poster
                    self.imageUploadIndicator.stopAnimating()
                }
            }
        }
    }
    
    // Fetches the series name and ids and updates the genre ids UI depending on the wihch ids does the series or movie has:
    private func setupGenres(){
        var selectedGenreNames : [String] = []

        if isMovieSelected {
            MovieService.fetchMovieGenres { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let genres):
                    let selectedGenreIds = self.selectedMovie?.genre_ids ?? []
                    for genre in genres{
                        for selectedGenre in selectedGenreIds{
                            if selectedGenre == genre.id{
                                selectedGenreNames.append(genre.name)
                            }
                        }
                    }
                }
            }
        }else{
            TVService.fetchTVGenres { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let genres):
                    let selectedGenreIds = self.selectedSeries?.genre_ids ?? []
                    for genre in genres{
                        for selectedGenre in selectedGenreIds{
                            if selectedGenre == genre.id{
                                selectedGenreNames.append(genre.name)
                            }
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.genres.text = ""

            for genreName in selectedGenreNames{
                
                if selectedGenreNames.last == genreName {
                    self.genres.text! += genreName
                }else{
                    self.genres.text! += "\(genreName) / "
                }
            }
        }
        
    }
}
