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
                
                let title = data["title"] as? String ?? ""
                let description = data["note"] as? String ?? ""
                let uid = data["uid"] as? String ?? ""
                let time = data["time"] as? String ?? ""
                
                let note = Notes(title: title, description: description, uid: uid, time: time)
              
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
        
    
}
