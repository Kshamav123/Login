//
//  RealmManager.swift
//  Login1
//
//  Created by Kshama Vidyananda on 30/10/21.
//

import Foundation
import RealmSwift

struct RealmManager {
    
    static var shared = RealmManager()
    let realmInstance = try! Realm()
    var notesRealm : [NotesRealm] = []
    
    func addNote(note : NotesRealm) {
        
        try!realmInstance.write({
            
            realmInstance.add(note)
        })
    }
    
    mutating func deleteNote(note: NotesRealm) {
        
        try! realmInstance.write({
            realmInstance.delete(note)
        })
        
    }
    
    
    func updateNote(title: String, description: String, note: NotesRealm){
        
        try! realmInstance.write {
          
            note.title = title
            note.note = description
            
        }
        
    }
    
    mutating func fetchNotes(completion: @escaping([NotesRealm]) -> Void) {
        
        var notesArray :[NotesRealm] = []
        let notes = realmInstance.objects(NotesRealm.self)
        
        for note in notes {
            
            notesRealm.append(note)
            notesArray.append(note)
        }
        
        completion(notesArray)
//        print(notes)
    }
}
