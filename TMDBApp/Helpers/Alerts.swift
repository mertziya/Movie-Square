//
//  Alerts.swift
//  TMDBApp
//
//  Created by Mert Ziya on 20.01.2025.
//

import Foundation
import UIKit

class Alerts {
    
    static func showAlert(vc: UIViewController , _title : String , _message : String){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        vc.present(alert, animated: true)
        
    }
    
}
