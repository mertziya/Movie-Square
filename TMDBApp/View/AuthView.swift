//
//  AuthView.swift
//  TMDBApp
//
//  Created by Mert Ziya on 12.01.2025.
//

import Foundation
import UIKit


protocol AuthViewDelegate : AnyObject {
    func didTapGoogleLoginButton()
}

class AuthView : UIView{
    
    weak var delegate : AuthViewDelegate?
    
    let backgroundImage = UIImageView()
    let logo = UIImageView()
    let signInLabel = UILabel()
    let googleSignInButton = UIButton()
    let GSMsignIn = UIButton()
    
    
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
        addSubview(GSMsignIn)
        
        
        
        backgroundColor = .systemBackground
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
        
        googleSignInButton.backgroundColor = .label
        googleSignInButton.setTitle("  Sign In with Google", for: .normal)
        googleSignInButton.setTitleColor(.systemBackground, for: .normal)
        googleSignInButton.setImage(UIImage.btnSigninwithGoogle, for: .normal)
        googleSignInButton.layer.cornerRadius = 44 / 2
        
        GSMsignIn.backgroundColor = .lightGray
        GSMsignIn.setTitle("  Sign In with GSM", for: .normal)
        GSMsignIn.setTitleColor(.systemBackground, for: .normal)
        GSMsignIn.setImage(UIImage.phone, for: .normal)
        GSMsignIn.layer.cornerRadius = 44 / 2
        
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        GSMsignIn.translatesAutoresizingMaskIntoConstraints = false
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
            
            GSMsignIn.centerXAnchor.constraint(equalTo: centerXAnchor),
            GSMsignIn.heightAnchor.constraint(equalToConstant: 44),
            GSMsignIn.widthAnchor.constraint(equalToConstant: 250),
            GSMsignIn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -250),
            
            googleSignInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 44),
            googleSignInButton.widthAnchor.constraint(equalToConstant: 250),
            googleSignInButton.bottomAnchor.constraint(equalTo: GSMsignIn.topAnchor, constant: -32),
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
    
}
