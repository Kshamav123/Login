//
//  ReminderViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 08/11/21.
//

import UIKit

class ReminderViewController: UIViewController {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let layout = UICollectionViewFlowLayout()
    var remindNotes: [Notes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchNotes()
        configureCollectionView()
        view.backgroundColor = .purple
//        collectionView.backgroundColor = .purple
        
    }
    
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func fetchNotes() {
        
        NetworkManager.manager.fetchRemindNotes { result in
            
            switch result {
                
            case .success(let notes):
                self.remindNotes = notes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                //                self.showAlert(title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    
    func configureCollectionView() {
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "cells")
        
    }
}

extension ReminderViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return remindNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cells" , for: indexPath) as! CollectionCell
        
        let note = remindNotes[indexPath.row]
        cell.titleLable.text = note.title
        cell.descriptionLabel.text = note.description
        
        return cell
    }
}

extension ReminderViewController: UICollectionViewDelegate {
    
    
}


extension ReminderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 20, height: 150)
    }
}
