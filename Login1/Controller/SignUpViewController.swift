//
//  SignUpViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 19/10/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
    }
    
  
    
    
    func validateFields() -> String?{
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
           // return "Please fill in all fields"
           showAlert(title: "Error", message: "Please fill in all fields")
        }
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Validation.isEmailValid(cleanedEmail) == false {
          //  return "Please enter the password properly"
            showAlert(title: "Error", message: "Please enter the email properly for e.g abc@xyz.com with any domain")
        }
        
        if Validation.isPasswordValid(cleanedPassword) == false {
          //  return "Please enter the password properly"
            showAlert(title: "Error", message: "Please enter the password properly")
        }

        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        
        let error = validateFields()
        if error != nil {
           
           //showError(error!)
        } else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

           
                NetworkManager.manager.signUp(withEmail: email, password: password) { [weak self] result, err in
                    
                if  err != nil {
                    self!.showAlert(title: "Error", message: "Error creating user")
                   // self.showError("Error creating user")
                } else{
     
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                           // self.showError("error in saving user data ")
                            self!.showAlert(title: "Error", message: "Error in saving user data")
                        }
                        
                    }
                    
                    self!.transitionToHome()
                }
            }
            
        }
    }
}




