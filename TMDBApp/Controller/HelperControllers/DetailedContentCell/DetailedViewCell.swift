//
//  CollectionViewCell.swift
//  TMDBApp
//
//  Created by Mert Ziya on 16.01.2025.
//

import UIKit
import Cosmos

class DetailedViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var bookmarkToShow: UIImageView!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        contentImage.layer.cornerRadius = 16
        
        ratingView.settings.fillMode = .precise
        ratingView.backgroundColor = .clear
    }

}
