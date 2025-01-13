//
//  WideMovieCell.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import UIKit
import Cosmos

class WideMovieCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var saveMovieButton: UIButton!
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        movieImage.layer.cornerRadius = 16
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
        
        saveMovieButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        movieImage.isUserInteractionEnabled = true
        movieImage.addGestureRecognizer(imageGesture)
        
        ratingStars.settings.fillMode = .precise
        
        
        
        indicatorConstraints()
    }
    
    @objc private func bookmarkTapped(){
        print("bookmark tapped")
    }

    @objc private func imageTapped(){
        print("image tapped")
    }
    
    private func indicatorConstraints(){
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: movieImage.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: movieImage.centerYAnchor),
        ])
    }
    
    
}
