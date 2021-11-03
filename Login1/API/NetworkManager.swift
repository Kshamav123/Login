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
                let description = data["note"] as? String ?? ""
                let uid = data["uid"] as? String ?? ""
                let time = data["time"] as? String ?? ""
                
                let note = Notes(id: id, title: title, description: description, uid: uid, time: time)
                
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
        db.collection("notes").document(note.id).updateData(["title": note.title, "note": note.description]) {
            error in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
        
    }
    
    func deleteNote(note: Notes) {
        
        let db = Firestore.firestore()
        db.collection("notes").document(note.id).delete {
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
                    let note = Notes(id: document.documentID, title: documentData["title"] as! String, description: documentData["note"] as! String, uid: documentData["uid"] as! String , time: documentData["time"] as! String)
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
    
    func fetchNotesToPagenate(completion: @escaping([Notes]) -> Void) {
        
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        var notes :[Notes] = []
        db.collection("notes").whereField("uid", isEqualTo: uid!).limit(to: 10).getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    let note = Notes(id: document.documentID, title: documentData["title"] as! String, description: documentData["note"] as! String, uid: documentData["uid"] as! String , time: documentData["time"] as! String)
                    notes.append(note)
                }
                lastDoc = snapshot!.documents.last
//                print(notes)
                completion(notes)
            }
        }
        
    }
}
