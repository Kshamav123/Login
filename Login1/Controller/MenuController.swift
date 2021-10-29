//
//  MenuController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 26/10/21.
//

import UIKit

class MenuController: UITableViewController {
    
    
    var delegate : MenuDelegate?
   
    
    var list = ["Account","Settings","Logout"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 80
       

 
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        cell.title.text = list[indexPath.row]
       

        return cell
   
   
}
    
  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if list[indexPath.row] == "Logout" {
//
//            let isSignedOut = NetworkManager.manager.signout()
//
//            if isSignedOut {
//                transitionToLogin()
//            }
//        }
        
        switch list[indexPath.row] {
        case "Account":

            print("")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let accountViewController = storyboard.instantiateViewController(withIdentifier: "AccountVC") as? AccountViewController
            accountViewController?.modalPresentationStyle = .fullScreen
            present(accountViewController!,animated: true,completion: nil)
         
            
        case "Logout":
            let isSignedOut = NetworkManager.manager.signout()

            if isSignedOut {
                transitionToLogin()
            }
            
        case "Settings":

         print("")
        
            
        default:
            print("++++++++++++++++")
        }
    }

}
