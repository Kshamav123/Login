//
//  DatabaseManager.swift
//  Login1
//
//  Created by Kshama Vidyananda on 05/11/21.
//

import Foundation

struct DatabaseManager {
    static let shared = DatabaseManager()
    
    func updateNote(note:Notes , realmNote:NotesRealm,title:String,content:String)
        {
            NetworkManager.manager.updateNote(note: note)
            RealmManager.shared.updateNote(title: title, description: content, note: realmNote)
        }
    
    func addNote(note:[String:Any],realmNote:NotesRealm)
    {
        NetworkManager.manager.addNote(note: note)
//        RealmManager.shared.addNote(note: realmNote)
    }

    func deleteNote(note: Notes, realmNote:NotesRealm) {
        
        NetworkManager.manager.deleteNote(note: note)
        RealmManager.shared.deleteNote(note: realmNote)
    }
}
