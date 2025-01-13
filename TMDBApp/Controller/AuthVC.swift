//
//  ViewController.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthVC: UIViewController, AuthViewDelegate {
    func didTapGoogleLoginButton() {
        AuthService.shared.signInUsingGoogle(vc: self)
    }
    
    
    var authView = AuthView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = authView
        authView.delegate = self
    }

}

