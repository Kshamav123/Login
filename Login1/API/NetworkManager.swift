//
//  NetworkManager.swift
//  Login1
//
//  Created by Kshama Vidyananda on 21/10/21.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

var isLoadingMoreNotes = false
var lastDoc: QueryDocumentSnapshot?

struct NetworkManager {
    
    static let manager = NetworkManager()
    
    func signUp(withEmail email: String, password: String, completion:AuthDataResultCallback?){
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func login(withEmail email: String, password: String, completion:AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    func signout() -> Bool{
        
        do {
            try Auth.auth().signOut()
            
        }catch{
            
        }
        return true
    }
    
    func googleSignOut(){
        do {
            try GIDSignIn.sharedInstance.signOut()
        }catch{
            
        }
    }
    
    func getUID() -> String? {
        
        return Auth.auth().currentUser?.uid
    }
    
    func addNote(note: [String: Any]) {
        
        let db = Firestore.firestore()
        db.collection("notes").addDocument(data: note)
        
    }
    
    func getNotes( completion: @escaping([Notes]) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("notes").whereField("uid", isEqualTo: NetworkManager.manager.getUID()).getDocuments() { snapshot, error in
            
            var notes = [Notes]()
            
            if let error = error {
                
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            for document in snapshot.documents {
                
                let data = document.data()
                let id = document.documentID
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let uid = data["uid"] as? String ?? ""
                let time = data["time"] as? String ?? ""
                let reminderTime = data["reminder time"] as? Date
                let isArchive = data["isArchive"] as? Bool ?? false
                
                let note = Notes(id: id, title: title, description: description, uid: uid, time: time, isArchive: isArchive)
                
                notes.append(note)
                
            }
            
            completion(notes)
        }
        
    }
    
    func addNoteToFirebase(note: Notes, completion: @escaping(Error?) -> Void) {
        
        
        
        let db = Firestore.firestore()
        db.collection("notes").addDocument(data: note.dictionary)
        //        let dictionary = note.dictionary as? [String: Any]
        //        db.collection("notes").addDocument(data: dictionary!) { error in
        
        //            completion(error)
        
    }
    
    func updateNote(note: Notes) {
        
        let db = Firestore.firestore()
        db.collection("notes").document(note.id!).updateData(note.dictionary) {
            error in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
        
    }
    
    func deleteNote(note: Notes) {
        
        let db = Firestore.firestore()
        db.collection("notes").document(note.id!).delete {
            error in
            
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchMoreNotesToPagenate(completion: @escaping([Notes]) -> Void) {
        
        print("???????????????????????????????")
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        var notes : [Notes] = []
        guard let lastDocument = lastDoc else { return }
        isLoadingMoreNotes = true
        db.collection("notes").start(afterDocument: lastDocument).limit(to: 10).getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                
                for document in snapshot!.documents {
                    print(">>>>>>>>>>>>>>>>>>>>>>.>>>>>..")
                    let documentData = document.data()
                    let isArchive = documentData["isArchive"] as? Bool ?? false
                    let note = Notes(id: document.documentID, title: documentData["title"] as! String, description: documentData["description"] as! String, uid: documentData["uid"] as! String , time: documentData["time"] as! String, isArchive: isArchive)
                    notes.append(note)
                }
                lastDoc = snapshot!.documents.last
                print("{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{")
                //                print(notes)
                isLoadingMoreNotes = false
                print("\(notes.count)-------------------------------------")
                completion(notes)
            }
        }
    }
    
    func fetchNotesToPagenate(archivedNotes: Bool, completion: @escaping([Notes]?, Error?) -> Void) {
        
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        var notes :[Notes] = []
        db.collection("notes").whereField("uid", isEqualTo: uid).whereField("isArchive", isEqualTo: archivedNotes).limit(to: 10).getDocuments { snapshot, error in
            //        db.collection("notes").whereField("uid", isEqualTo: uid!).limit(to: 10).getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    let isArchive = documentData["isArchive"] as? Bool ?? false
                    let note = Notes(id: document.documentID, title: documentData["title"] as! String, description: documentData["description"] as! String, uid: documentData["uid"] as! String , time: documentData["time"] as! String, isArchive: isArchive)
                    notes.append(note)
                }
                lastDoc = snapshot!.documents.last
                //                print(notes)
                completion(notes, nil)
            }
        }
        
    }
    
    func resultType(archivedNotes: Bool, completion: @escaping(Result<[Notes], Error>) -> Void) {
        
        guard let uid = NetworkManager.manager.getUID() else { return }
        let db = Firestore.firestore()
        var notes :[Notes] = []
        db.collection("notes").whereField("uid", isEqualTo: uid).whereField("isArchive", isEqualTo: archivedNotes).limit(to: 10).getDocuments { snapshot, error in
            //        db.collection("notes").whereField("uid", isEqualTo: uid).limit(to: 10).getDocuments { snapshot, error in
            
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                let documentData = document.data()
                let isArchive = documentData["isArchive"] as? Bool ?? false
                let note = Notes(id:  document.documentID, title: documentData["title"] as! String, description: documentData["description"] as! String, uid: documentData["uid"] as! String, time: documentData["time"] as! String, isArchive: isArchive)
                
                notes.append(note)
            }
            lastDoc = snapshot.documents.last
            print(notes.count)
            completion(.success(notes))
        }
    }
    
    func fetchRemindNotes(completion: @escaping(Result<[Notes], Error>) -> Void) {
        
        guard let uid = NetworkManager.manager.getUID() else { return }
        let nilValue: Date? = nil

//        db.collection("notes").whereField("reminderTime", isNotEqualTo:  nilValue).getDocuments
        let db = Firestore.firestore()
        db.collection("notes").whereField("uid", isEqualTo: uid).whereField("reminderTime", isNotEqualTo:  nilValue).getDocuments { snapshot, error in
            
            var notes :[Notes] = []
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                let documentData = document.data()
                let isArchive = documentData["isArchive"] as? Bool ?? false
                let reminderTime = (documentData["reminderTime"] as? Timestamp)?.dateValue() ?? Date()

                let note = Notes(id: document.documentID, title: documentData["title"] as! String, description: documentData["description"] as! String, uid: documentData["uid"] as! String, time: documentData["time"] as! String, isArchive: isArchive, reminderTime: reminderTime)
                
                notes.append(note)
                
            }
            lastDoc = snapshot.documents.last
            completion(.success(notes))
        }
    }
}
