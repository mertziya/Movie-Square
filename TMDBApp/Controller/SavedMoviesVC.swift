//
//  AccountVC.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import Foundation
import UIKit
import FirebaseAuth

class SavedMoviesVC : UIViewController{
    
    var accountView = SavedMoviesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = accountView
        setupNavigation()
    }
    
    
    private func setupNavigation(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(logOut))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // Ensures a solid color
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.1) // Set your desired color
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance

    }
    @objc private func logOut(){
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let exitAction = UIAlertAction(title: "Exit", style: .destructive) { alert in
            do{
                try Auth.auth().signOut()
                let authVC = AuthVC()
                authVC.modalPresentationStyle = .fullScreen
                self.present(authVC, animated: true)
            }catch{
                print("ERROR")
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(exitAction)
     

        present(alert, animated: true)
    }
    
}
