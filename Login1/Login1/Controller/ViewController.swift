//
//  ViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 19/10/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController {
    
    
    //MARK :- Properties
    
    let signInConfig = GIDConfiguration.init(clientID: "918208608044-8sp317ibu4p06pvt8rl6ckvsa5o0c7d5.apps.googleusercontent.com")
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var googlesignInButton: GIDSignInButton!
    @IBOutlet weak var btnFB: FBLoginButton!
    
    //MARK :- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserAlreadyLoggedIn()
    }
    
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        if Auth.auth().currentUser?.uid != nil{
    //            transitionToHome()
    //        }
    //    }
    
    //MARK :- Actions
    
    @IBAction func loginTapped(_ sender: UIButton) {
  
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        NetworkManager.manager.login(withEmail: email, password: password) { [weak self]result, error in
            
            if error != nil{
                
                self!.showAlert(title: "Error", message: "Could not login in")
                
            }
            else{
                self!.transitionToHome()
                
            }
        }
    }
    
    @IBAction func googleSignInTapped(_ sender: UIButton) {
        
        print("tapped")
        signInGoogle()
    }
    
    //MARK :- Helpers
    
    func signInGoogle() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            if let error = error {
                showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    let authError = error as NSError
                    print(error.localizedDescription)
                    print(authError)
                }
                else {
                    
                    transitionToHome()
                    
                }
            }
            
        }
    }
    
    func checkUserAlreadyLoggedIn(){
        //Previous sign in
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error == nil || user != nil {
                // Show the app's signed-in state.
                self.transitionToHome()
            }
            else {
                return
            }
        }
        
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            self.transitionToHome()
        }
        else{
            
            btnFB.permissions = ["public_profile", "email"]
            btnFB.delegate = self
        }
    }
}

//MARK :- LoginButtonDelegate

extension ViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { connection, result, error in
            
            print("\(result)")
        }
        self.transitionToHome()
    }
    
func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    
        print("Log out")
    }
    
}

