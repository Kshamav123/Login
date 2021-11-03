//
//  AccountViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 27/10/21.
//

import UIKit
import FirebaseStorage
import Photos
import Firebase
import FirebaseAuth
import FirebaseStorageUI

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageView.layer.cornerRadius = 30
//        imageView.layer.masksToBounds = true
//        view.addSubview(imageView)
        profileImage()
        checkPermission()
        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
        
        print("tapped")
        
        
    }
    
    
    
    func checkPermission() {
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
        } else {
            
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
            print("We have access to photos")
        } else{
            
            print("We dont have access to photos")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            print(url)
            uploadToCloud(fileURL: url)
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
        
    }
    
    func uploadToCloud(fileURL: URL) {
        let uid = Auth.auth().currentUser?.uid
        let storage = Storage.storage()

        let storageRef = storage.reference()
        
        let localFile = fileURL
        let photoRef = storageRef.child(uid!)
        let uploadTask =  photoRef.putFile(from: localFile, metadata: nil) { (metadata,err) in
            
            guard let metadata = metadata else {
                print(err?.localizedDescription)
                return
            }
            print("Photo upload")
            self.profileImage()
        }
    }
    
    func profileImage(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return}
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(uid)
        ref.getData(maxSize: 5 * 1024 * 1024) { data ,error in
            if let error = error {
                
                
            }else {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}
