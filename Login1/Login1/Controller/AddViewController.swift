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
import UserNotifications

class AddViewController: UIViewController {
    
    //MARK :- Properties
    
    var isNew: Bool = true
    var note: Notes?
    var notesRealm: NotesRealm?
//    let realmInstance = try! Realm()
  
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var reminderTimes: UIDatePicker!
    
    var reminder: Date? = nil
    //MARK :- Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        if !isNew {
            newData()
        }
    }
    
    //MARK :- Actions
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteNotesButton(_ sender: UIButton) {
        
        NetworkManager.manager.deleteNote(note: note!)
//        RealmManager.shared.deleteNote(note: notesRealm!)
//       DatabaseManager.shared.deleteNote(note: note!, realmNote: notesRealm!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNotesButton(_ sender: UIButton) {
        
//        guard let title = titleTextField.text else {return}
//        guard let description = descriptionTextView.text else {return}
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        let reminderTime = reminderTimes?.date else {return}

        if titleTextField.text == "" || descriptionTextView.text == "" {
            showAlert(title: "Notes", message: "Fields cannot be empty")

        }else if isNew {


//            let newNote: [String: Any] = ["title": title, "note": description, "uid": uid, "time" : getCurrentDate(),"reminderTime": reminder]
            let newNote1 = Notes(title:titleTextField.text!, description: descriptionTextView.text,uid: NetworkManager.manager.getUID()!,time : getCurrentDate(),isArchive: false, reminderTime: reminder)
            
            if newNote1.reminderTime != nil {
            notificationReminder(note: newNote1)
            }
            
            let newNoteRealm = NotesRealm()
            newNoteRealm.note = descriptionTextView.text
            newNoteRealm.title = titleTextField.text!
            newNoteRealm.uid = NetworkManager.manager.getUID()!
            newNoteRealm.time = Date()
            newNoteRealm.reminderTime = reminderTimes.date

            NetworkManager.manager.addNote(note: newNote1.dictionary)
//            RealmManager.shared.addNote(note: newNoteRealm)
//            DatabaseManager.shared.addNote(note: newNote, realmNote: newNoteRealm)
            dismiss(animated: true, completion: nil)

        } else {

        
            note?.title = titleTextField.text!
            note?.description = descriptionTextView.text
            note?.reminderTime = reminder
            if note?.reminderTime != nil {
                notificationReminder(note: note!)
                
            }
            NetworkManager.manager.updateNote(note: note!)
//            RealmManager.shared.updateNote(title: titleTextField.text!, description: descriptionTextView.text, note: notesRealm!)
//            DatabaseManager.shared.updateNote(note: note!, realmNote: notesRealm!, title: titleTextField.text!, content: descriptionTextView.text)
            dismiss(animated: true, completion: nil)
        }
        
        
    }
    

    @IBAction func archivedButton(_ sender: UIButton) {
        
        print("Arcvived")
        note!.isArchive = !note!.isArchive
        NetworkManager.manager.updateNote(note: note!)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func reminderButton(_ sender: UIButton) {
      
        reminder = reminderTimes.date
//        self.note?.reminderTime = reminder
             
    }
   
    
    //MARK :- Helpers
    
    func notificationReminder(note : Notes){
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in

//            for note in self.note {

        let content = UNMutableNotificationContent()
        content.title = note.title
        content.sound = .default
        content.body = note.description

                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: note.reminderTime!), repeats: false)

        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in

            if error != nil {
                print("something went wrong")
            }

        })
//        }
    }
    }
    
    func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
        
    }
    
    func newData() {
        
        titleTextField.text = note?.title
        descriptionTextView.text = note?.description
        
//        titleTextField.text = notesRealm?.title
//        descriptionTextView.text = notesRealm?.description
        
        
    }
    
 
}

