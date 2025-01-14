//
//  DetailVC.swift
//  TMDBApp
//
//  Created by Mert Ziya on 14.01.2025.
//

import UIKit
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
    
    
    @IBOutlet weak var ratingValue: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    
    
    // MARK: - Lifecycles:
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupConstraints() // For extra constraints made with the percantage values.
        
        setupUI() // For extra UI Configurations that couldn't be handled with XIB File
        
        fetchBackgroundImage() // Fetches the image that is coming from the data.
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        
        // Removes the left bar button item of the navigation controller since another design will be used [According to the design resource]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
    }
    
    @objc private func buttonTouchDown(){
        downloadButton.alpha = 0.5 // Higlighted state
    }
    @objc private func buttonTouchUp(){
        downloadButton.alpha = 1.0 // Normal State
    }
}





// MARK: - Advanced Constraints:
extension DetailVC{
    private func setupConstraints(){
        imageToShow.addSubview(imageUploadIndicator)
        
        imageUploadIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageToShow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageUploadIndicator.centerXAnchor.constraint(equalTo: imageToShow.centerXAnchor),
            imageUploadIndicator.centerYAnchor.constraint(equalTo: imageToShow.centerYAnchor),
            
            imageToShow.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.68)
        ])
    }
}



// MARK: - Network Calls:
extension DetailVC{
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
}
