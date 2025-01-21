//
//  Animations.swift
//  TMDBApp
//
//  Created by Mert Ziya on 16.01.2025.
//

import Foundation
import UIKit

class Animations{
    
    static func showBookmarkAnimation(vc : UIViewController, isBookmarked: Bool, isMovies : Bool) {
        // Create the UIImageView with a system image
        let animationView = UIView()
        animationView.backgroundColor = .systemGray.withAlphaComponent(0.7)
        animationView.layer.cornerRadius = 32
        
        let informMessage = UILabel()
        informMessage.text = isMovies ? (isBookmarked ? "Movie Saved" : "Movie Removed") : (isBookmarked ? "Series Saved" : "Series Removed")
        informMessage.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        
        let imageView = isBookmarked ? UIImageView(image: UIImage(systemName: "bookmark.fill")) : UIImageView(image: UIImage(systemName: "bookmark"))
        imageView.tintColor = isBookmarked ? .systemYellow : .white // Set the image tint color
        imageView.alpha = 0.7
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        informMessage.translatesAutoresizingMaskIntoConstraints = false
        
        vc.view.addSubview(animationView)
        animationView.addSubview(imageView)
        animationView.addSubview(informMessage)
        // Center the image view
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor , constant: 104),
            animationView.widthAnchor.constraint(equalToConstant: 240),
            animationView.heightAnchor.constraint(equalToConstant: 240),
            
            imageView.topAnchor.constraint(equalTo: animationView.topAnchor, constant: 5),
            imageView.centerXAnchor.constraint(equalTo: animationView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            imageView.widthAnchor.constraint(equalToConstant: 180),
            
            informMessage.bottomAnchor.constraint(equalTo: animationView.bottomAnchor, constant: -20),
            informMessage.centerXAnchor.constraint(equalTo: animationView.centerXAnchor),
            
        ])
        
        // Create a fade-in and fade-out animation
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0
        fadeAnimation.beginTime = 0
        fadeAnimation.duration = 0
        fadeAnimation.fillMode = .forwards
        fadeAnimation.isRemovedOnCompletion = false
        
        
        // Create a delay animation (to keep the visible state for 2 seconds)
        let delayAnimation = CABasicAnimation(keyPath: "opacity")
        delayAnimation.fromValue = 1.0
        delayAnimation.toValue = 1.0
        delayAnimation.duration = 1.0

        // Group the animations
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [delayAnimation, fadeAnimation]
        animationGroup.duration = 1.0 // Total duration (2 seconds delay + 0.4 seconds fade-out)
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false

        // Add the animation group to your layer
        animationView.layer.add(animationGroup, forKey: "fadeAnimation")
        
        // Remove the image view after the animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            animationView.removeFromSuperview()
        }
    }

    
}
