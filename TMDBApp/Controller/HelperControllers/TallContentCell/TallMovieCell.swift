//
//  TallMovieCell.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import UIKit
import Cosmos

class TallMovieCell: UICollectionViewCell {

    static let reuseID = "tallmoviecellreuseID"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingCosmosView: CosmosView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .systemBackground
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.image = UIImage.solidGray
        
        ratingCosmosView.backgroundColor = .clear
    }
    
    private func setupIndicator(){
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }

}
