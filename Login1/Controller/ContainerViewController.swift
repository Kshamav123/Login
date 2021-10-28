//
//  ContainerViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 25/10/21.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var menuController: MenuController!
    var centreController: UIViewController!
    var isExpandMenu : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHome()
//        configureMenuController()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
        
    }
    
    func configureHome(){
        
        let home = HomeViewController()
        home.delegate = self
         centreController = UINavigationController(rootViewController: home)
       
        self.view.addSubview(centreController.view)
        addChild(centreController)
        centreController.didMove(toParent: self)
        

        
    }
    
    func configureMenu(){
        
        if menuController == nil {
            //add menu controller here
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            menuController = storyboard.instantiateViewController(withIdentifier: "MenuController") as! MenuController
            self.view.addSubview(menuController.view)
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
            print("Did add menu controller")
        }
        
    }
    
    func showMenu(isExpand: Bool){

        if isExpand{
            //show menu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {

                self.centreController.view.frame.origin.x = self.centreController.view.frame.width - 80

            }, completion: nil)

        }else{
            //hide menu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {

                self.centreController.view.frame.origin.x = 0

            }, completion: nil)

        }
        configureStatusBarAnim()
    }
    
    func configureStatusBarAnim() {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        
    }, completion: nil)
        
    }
    
}


extension ContainerViewController: MenuDelegate{
    func menuHandler(index : Int) {
        print("inside the func")
        if !isExpandMenu{
            print("extension")
            configureMenu()
        }
        
        isExpandMenu = !isExpandMenu
        showMenu(isExpand: isExpandMenu)
    }
    
    
       
    }
    
    
    

