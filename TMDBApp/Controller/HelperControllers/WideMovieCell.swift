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
        
        let imageLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(imageLongPressed(_:)))
        imageLongPressGesture.minimumPressDuration = 0.4
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        movieImage.isUserInteractionEnabled = true
        movieImage.addGestureRecognizer(imageTapGesture)
        movieImage.addGestureRecognizer(imageLongPressGesture)
        
        ratingStars.settings.fillMode = .precise
        
        
        
        indicatorConstraints()
    }
    
    @objc private func bookmarkTapped(){
        print("bookmark tapped")
    }

    @objc private func imageLongPressed(_ longpress: UILongPressGestureRecognizer){
        switch longpress.state{
        case .began:
            movieImage.alpha = 0.5
        case .changed, .ended, .cancelled, .failed:
            movieImage.alpha = 1.0
        default:
            break
        }
    }
    
    @objc private func imageTapped(){
        print("Tapped")
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
