//
//  Notes.swift
//  Login1
//
//  Created by Kshama Vidyananda on 27/10/21.
//

import Foundation
 import FirebaseFirestore

struct Notes {
    var id : String
    var title: String
    var description: String
    var uid: String
    var time: String
    
    var dictionary: [String: Any] {
           return[
            "id": id,
           "title": title,
           "description": description,
           "uid":uid,
           "time":time
      
           ]
       }
}
