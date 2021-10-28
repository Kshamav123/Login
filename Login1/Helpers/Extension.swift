//
//  Helper.swift
//  Login1
//
//  Created by Kshama Vidyananda on 20/10/21.
//

import Foundation
import UIKit
import FirebaseAuth

extension UIViewController {
     
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "ok", style: .default) { (okClicked) in
        }
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
                            
    func transitionToHome(){
        
       let homeViewController =  storyboard?.instantiateViewController(withIdentifier: "ContainerVc") 
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToLogin(){
        
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as? ViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
  
}
