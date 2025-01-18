//
//  SliderCell.swift
//  TMDBApp
//
//  Created by Mert Ziya on 17.01.2025.
//

import Foundation
import UIKit

class SliderCell : UICollectionViewCell {
    
    static let reuseID = "SlideCellReuseIdentifier"
 
    var label = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        

        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        
        backgroundColor = #colorLiteral(red: 0.1647058725, green: 0.1647058725, blue: 0.1647058725, alpha: 1)
        layer.cornerRadius = bounds.height / 2
        
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
