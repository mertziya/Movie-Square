//
//  RegisterView.swift
//  TMDBApp
//
//  Created by Mert Ziya on 25.01.2025.
//

import Foundation
import UIKit
import FirebaseAuth

class RegisterView : UIViewController{
    
    let password = UITextField()
    let repeatpassword = UITextField()
    let email = UITextField()
    let signupButton = UIButton()
    let logo = UIImageView()
    
    let backgroundImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc private func signupTapped(){
        if password.text != repeatpassword.text{
            Alerts.showAlert(vc: self, _title: "Check Credentials", _message: "Passwords should match!")
        }else{
            FirebaseService.shared.createUser(email: email.text ?? "", password: password.text ?? "") { error in
                if let error = error{
                    DispatchQueue.main.async {
                        Alerts.showAlert(vc: self, _title: "Error!", _message: error.localizedDescription)

                    }
                }else{
                    FirebaseService.shared.createUserInFirestore(user: Auth.auth().currentUser!)
                    DispatchQueue.main.async {
                        let tabBarVC = TabVC()
                        tabBarVC.modalPresentationStyle = .fullScreen
                        self.present(tabBarVC , animated: true)
                    }
                }
            }
        }
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(backgroundImage)
        view.addSubview(repeatpassword)
        view.addSubview(password)
        view.addSubview(email)
        view.addSubview(signupButton)
        view.addSubview(logo)
        
        backgroundImage.image = UIImage.loginBg
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.12
        backgroundImage.clipsToBounds = true
        
        password.layer.cornerRadius = 44 / 2
        password.placeholder = "Password"
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.systemGray.cgColor
        password.backgroundColor = .darkGray.withAlphaComponent(0.2)
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        password.leftViewMode = .always
        password.isSecureTextEntry = true
        
        
        repeatpassword.layer.cornerRadius = 44 / 2
        repeatpassword.placeholder = "Repeat Password"
        repeatpassword.layer.borderWidth = 1
        repeatpassword.layer.borderColor = UIColor.systemGray.cgColor
        repeatpassword.backgroundColor = .darkGray.withAlphaComponent(0.2)
        repeatpassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        repeatpassword.leftViewMode = .always
        repeatpassword.isSecureTextEntry = true
        
        email.layer.cornerRadius = 44 / 2
        email.placeholder = "Email"
        email.layer.borderWidth = 1
        email.layer.borderColor = UIColor.systemGray.cgColor
        email.backgroundColor = .darkGray.withAlphaComponent(0.2)
        email.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        email.leftViewMode = .always
        
        signupButton.setTitle("Sign In", for: .normal)
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.backgroundColor = .link
        signupButton.layer.cornerRadius = 44 / 2
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        
        logo.image = UIImage.logo
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        
        
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        repeatpassword.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.bottomAnchor.constraint(equalTo: email.topAnchor, constant: -50),
            logo.heightAnchor.constraint(equalToConstant: 85),
            logo.widthAnchor.constraint(equalToConstant: 157),
            
            email.centerYAnchor.constraint(equalTo: view.centerYAnchor , constant: -180),
            email.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            email.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            email.heightAnchor.constraint(equalToConstant: 44),
            
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 28),
            password.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            password.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            password.heightAnchor.constraint(equalToConstant: 44),
            
            repeatpassword.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 28),
            repeatpassword.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            repeatpassword.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            repeatpassword.heightAnchor.constraint(equalToConstant: 44),
            
            signupButton.topAnchor.constraint(equalTo: repeatpassword.bottomAnchor, constant: 28),
            signupButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            signupButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            signupButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            
            
            
        ])
    }
    
}
