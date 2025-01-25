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
    func didTapSignInButton(email: String, password: String) {
        FirebaseService.shared.signUserInWithemail(email: email, password: password) { error in
            if let error = error{
                Alerts.showAlert(vc: self, _title: "Sign In Error", _message: error.localizedDescription)
            }else{
                let vc = TabVC()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    func didTapRegisterButton() {
        let vc = RegisterView()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapGoogleLoginButton() {
        FirebaseService.shared.signInUsingGoogle(vc: self)
    }
    
    
    var authView = AuthView()

    override func viewDidLoad() {
        super.viewDidLoad()
        authView.vc = self
        view = authView
        authView.delegate = self
    }

}

