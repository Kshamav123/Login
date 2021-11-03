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
import RealmSwift

class AddViewController: UIViewController {
    
   
    var isNew: Bool = true
    var note: Notes?
    var notesRealm: NotesRealm?
    let realmInstance = try! Realm()
    
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
        
//        titleTextField.text = notesRealm?.title
//        descriptionTextView.text = notesRealm?.description
        
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteNotesButton(_ sender: UIButton) {
        
    
        NetworkManager.manager.deleteNote(note: note!)
       RealmManager.shared.deleteNote(note: notesRealm!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNotesButton(_ sender: UIButton) {
        
        guard let title = titleTextField.text else {return}
        guard let description = descriptionTextView.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        if titleTextField.text == "" || descriptionTextView.text == "" {
            showAlert(title: "Notes", message: "Fields cannot be empty")
            
        }else if isNew{
            
            
            let newNote: [String: Any] = ["title": title, "note": description, "uid": uid, "time" : getCurrentDate()]
          
            
            let newNoteRealm = NotesRealm()
            newNoteRealm.note = descriptionTextView.text
            newNoteRealm.title = titleTextField.text!
            newNoteRealm.uid = NetworkManager.manager.getUID()!
            newNoteRealm.time = Date()
            
            NetworkManager.manager.addNote(note: newNote)
            RealmManager.shared.addNote(note: newNoteRealm)
            dismiss(animated: true, completion: nil)
            
        } else {
            note?.title = titleTextField.text!
            note?.description = descriptionTextView.text
            
            NetworkManager.manager.updateNote(note: note!)
            RealmManager.shared.updateNote(title: titleTextField.text!, description: descriptionTextView.text, note: notesRealm!)
            dismiss(animated: true, completion: nil)
        }
  
        
    }
    

    func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())

    }
}


