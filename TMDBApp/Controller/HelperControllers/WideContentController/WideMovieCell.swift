//
//  WideMovieCell.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import UIKit
import Cosmos


class WideMovieCell: UICollectionViewCell{
    
    // MARK: - Properties:
    var selectedMovie : Movie?
    var selectedSeries : Series?
    var isMovieSelected = true
        
    // MARK: - UI Configurations:
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    // MARK: - Lifecycles:
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
        
        movieImage.layer.cornerRadius = 16
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
                
        let imageLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(imageLongPressed(_:)))
        imageLongPressGesture.minimumPressDuration = 0.4
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        movieImage.isUserInteractionEnabled = true
        movieImage.addGestureRecognizer(imageTapGesture)
        movieImage.addGestureRecognizer(imageLongPressGesture)
        
        ratingStars.settings.fillMode = .precise
       
        
        indicatorConstraints()
        
    }

    @objc private func imageLongPressed(_ longpress: UILongPressGestureRecognizer){
        switch longpress.state{
        case .began:
            movieImage.alpha = 0.5
        case .ended:
            movieImage.alpha = 1.0
            if isMovieSelected{
                guard let selectedMovie = selectedMovie else{return}
                NotificationCenter.default.post(name: .imageTappedNotification, object: nil, userInfo: ["data" : selectedMovie])
            }else{
                guard let selectedSeries = selectedSeries else{return}
                NotificationCenter.default.post(name: .imageTappedNotification, object: nil, userInfo: ["data" : selectedSeries])
            }
        default:
            break
        }
    }
    
    @objc private func imageTapped(){
        if isMovieSelected{
            guard let selectedMovie = selectedMovie else{return}
            NotificationCenter.default.post(name: .imageTappedNotification, object: nil, userInfo: ["data" : selectedMovie])
        }else{
            guard let selectedSeries = selectedSeries else{return}
            NotificationCenter.default.post(name: .imageTappedNotification, object: nil, userInfo: ["data" : selectedSeries])
        }
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

//
//if issBookmarked{
//    self.saveMovieButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
//    self.saveMovieButton.tintColor = .systemYellow
//}
