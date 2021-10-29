//
//  AddViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 26/10/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AddViewController: UIViewController {
    
   
    var isNew: Bool = true
    var note: Notes?
    
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if !isNew {
            newData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func newData(){
        
        titleTextField.text = note?.title
        descriptionTextView.text = note?.description
        
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func deleteNotesButton(_ sender: UIButton) {
        
       
        NetworkManager.manager.deleteNote(note: note!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNotesButton(_ sender: UIButton) {
        
        if titleTextField.text == "" || descriptionTextView.text == "" {
            showAlert(title: "Notes", message: "Fields cannot be empty")
            
        }else if isNew{
            
            let newNote: [String: Any] = ["title": titleTextField.text, "note": descriptionTextView.text,"uid": NetworkManager.manager.getUID(),"time" : getCurrentDate()]
            NetworkManager.manager.addNote(note: newNote)
            dismiss(animated: true, completion: nil)
            
            //            let note = Notes(title: titleTextField.text!, description: descriptionTextView.text, uid: NetworkManager.manager.getUID()!, time: getCurrentDate())
            //            NetworkManager.manager.addNoteToFirebase(note: note) { error in
            //                if let error = error {
            //
            //                    print("Error while saving")
            //                }
            //            }
        } else {
            note?.title = titleTextField.text!
            note?.description = descriptionTextView.text
            
            NetworkManager.manager.updateNote(note: note!)
            dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
    
    
    
    func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        return dateFormatter.string(from: Date())
        
    }
}


