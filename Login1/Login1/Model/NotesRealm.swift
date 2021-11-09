//
//  NotesRealm.swift
//  Login1
//
//  Created by Kshama Vidyananda on 30/10/21.
//

import Foundation
import RealmSwift
import UIKit

class NotesRealm: Object  {
    
    @objc dynamic var title = ""
    @objc dynamic var note = ""
    @objc dynamic var uid = ""
    @objc dynamic var time = Date()
    @objc dynamic var reminderTime : Date?
}
