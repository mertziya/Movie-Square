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
}

class AuthView : UIView{
    
    weak var delegate : AuthViewDelegate?
    
    let versionLabel = UILabel()
    let backgroundImage = UIImageView()
    let logo = UIImageView()
    let signInLabel = UILabel()
    let googleSignInButton = UIButton()
    let creditsLink = UILabel()
    
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
        
        
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        creditsLink.translatesAutoresizingMaskIntoConstraints = false
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
            googleSignInButton.widthAnchor.constraint(equalToConstant: 250),
            googleSignInButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -320),
            
            versionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44),
            versionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            creditsLink.bottomAnchor.constraint(equalTo: versionLabel.topAnchor, constant: -44),
            creditsLink.centerXAnchor.constraint(equalTo: centerXAnchor),
            
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
    
}
