//
//  ReminderViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 08/11/21.
//

import UIKit

class ReminderViewController: UIViewController {
    
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var bodyField: UITextField!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var completion : ((String, String, Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
   
      
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        
    }
    

}

