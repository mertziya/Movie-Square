//
//  AuthView.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import Foundation
import UIKit
import WebKit


protocol AuthViewDelegate : AnyObject {
    func didTapGoogleLoginButton()
    func didTapSignInButton(email : String , password : String)
    func didTapRegisterButton()
}

class AuthView : UIView{
    
    weak var delegate : AuthViewDelegate?
    
    let versionLabel = UILabel()
    let backgroundImage = UIImageView()
    let logo = UIImageView()
    let signInLabel = UILabel()
    let googleSignInButton = UIButton()
    let creditsLink = UILabel()
    
    let email = UITextField()
    let password = UITextField()
    let signInButton = UIButton()
    
    let registerButton = UIButton()
    
    var vc : UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        googleSignIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
}

// MARK: - UI Configurations:
extension AuthView{
    private func setupUI(){
        insertSubview(backgroundImage, at: 0)
        addSubview(logo)
        addSubview(signInLabel)
        addSubview(googleSignInButton)
        addSubview(versionLabel)
        addSubview(creditsLink)
        
        let orLabel = UILabel()
        addSubview(orLabel)
        addSubview(email)
        addSubview(password)
        addSubview(signInButton)
        addSubview(registerButton)
        

        backgroundColor = .black
        backgroundImage.image = UIImage.loginBg
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.12
        backgroundImage.clipsToBounds = true
        
        logo.image = UIImage.logo
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        
        signInLabel.attributedText = NSAttributedString(string: "Sign In", attributes: [
            .font : UIFont.systemFont(ofSize: 22, weight: .light)
        ])
        signInLabel.textColor = .white
        
        googleSignInButton.backgroundColor = .white
        googleSignInButton.setTitle("  Sign In with Google", for: .normal)
        googleSignInButton.setTitleColor(.black, for: .normal)
        googleSignInButton.setImage(UIImage.btnSigninwithGoogle, for: .normal)
        googleSignInButton.layer.cornerRadius = 44 / 2
    
        versionLabel.text = "v: 1.0.0"
        versionLabel.textColor = .white
        versionLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        
        
        creditsLink.text = "This product uses the TMDB API but is not endorsed or certified by TMDB."
        creditsLink.textColor = .link
        creditsLink.font = UIFont.systemFont(ofSize: 8, weight: .medium)
        creditsLink.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openTMDBWeb))
        creditsLink.addGestureRecognizer(tapGesture)
        
        
        
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .link
        signInButton.layer.cornerRadius = 44 / 2
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        orLabel.text = "or"
        orLabel.textColor = .white
        
        password.layer.cornerRadius = 44 / 2
        password.placeholder = "Password"
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.systemGray.cgColor
        password.backgroundColor = .darkGray.withAlphaComponent(0.2)
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        password.leftViewMode = .always
        password.isSecureTextEntry = true
        
        email.layer.cornerRadius = 44 / 2
        email.placeholder = "Email"
        email.layer.borderWidth = 1
        email.layer.borderColor = UIColor.systemGray.cgColor
        email.backgroundColor = .darkGray.withAlphaComponent(0.2)
        email.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        email.leftViewMode = .always
        
        
        registerButton.setTitle("Sign up with email", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .gray
        registerButton.layer.cornerRadius = 44 / 2
        registerButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        creditsLink.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            backgroundImage.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            logo.centerXAnchor.constraint(equalTo: centerXAnchor),
            logo.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            logo.heightAnchor.constraint(equalToConstant: 85),
            logo.widthAnchor.constraint(equalToConstant: 157),
            
            signInLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 48),
            
            googleSignInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 44),
            googleSignInButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            googleSignInButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            googleSignInButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -200),
            
            versionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44),
            versionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            creditsLink.bottomAnchor.constraint(equalTo: versionLabel.topAnchor, constant: -44),
            creditsLink.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            orLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            orLabel.bottomAnchor.constraint(equalTo: googleSignInButton.topAnchor, constant: -50),
            
            signInButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            signInButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            signInButton.bottomAnchor.constraint(equalTo: googleSignInButton.topAnchor, constant: -100),
            signInButton.heightAnchor.constraint(equalToConstant: 44),
            
            password.heightAnchor.constraint(equalToConstant: 44),
            password.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            password.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            password.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -25),
            
            email.heightAnchor.constraint(equalToConstant: 44),
            email.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            email.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            email.bottomAnchor.constraint(equalTo: password.topAnchor, constant: -25),
            
            registerButton.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 12),
            registerButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            registerButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            registerButton.heightAnchor.constraint(equalToConstant: 44),
            
            
        ])
    }
}



// MARK: - Actions:
extension AuthView{
    
    private func googleSignIn(){
        googleSignInButton.addTarget(self, action: #selector(googleSignInAction), for: .touchUpInside)
    }
    @objc private func googleSignInAction(){
        delegate?.didTapGoogleLoginButton()
    }
    
    @objc private func openTMDBWeb() {
        // Create a new view controller to host the WebView
        let webViewController = UIViewController()
        
        // Set up the WKWebView
        let webView = WKWebView(frame: webViewController.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let url = URL(string: "https://www.themoviedb.org")!
        webView.load(URLRequest(url: url))
        webViewController.view.addSubview(webView)
        
        // Enable gesture-based dismissal
        webViewController.modalPresentationStyle = .pageSheet
        if let sheet = webViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // Allow scrolling between sizes
            sheet.prefersGrabberVisible = true // Add a grabber for better UX
        }
        
        // Present the WebView controller
        vc.present(webViewController, animated: true)
    }
    
    @objc private func signInTapped(){
        self.delegate?.didTapSignInButton(email: email.text ?? "", password: password.text ?? "")
    }
    
    @objc private func signUpTapped(){
        self.delegate?.didTapRegisterButton()
    }
    
}
