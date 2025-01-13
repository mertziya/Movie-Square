//
//  AuthService.swift
//  TMDBApp
//
//  Created by Mert Ziya on 13.01.2025.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthService{
    static var shared = AuthService()
    
    func signInUsingGoogle(vc : UIViewController){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { [unowned vc] result, error in
          guard error == nil else {
              print(error?.localizedDescription ?? "Error")
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            print("Token Error")
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error{
                    print(error.localizedDescription)
                }
                else if let _ = result{
                    DispatchQueue.main.async {
                        let tabBarVC = TabVC()
                        tabBarVC.modalPresentationStyle = .fullScreen
                        vc.present(tabBarVC , animated: true)
                    }
                }else{
                    print("Unknown Error")
                }
            }
        }
    }
}
