//
//  ArchiveViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 09/11/21.
//

import UIKit

class ArchiveCollectionViewController: UIViewController {
    
    
    @IBOutlet var notesCollectioView: UICollectionView!
    
    let layout = UICollectionViewFlowLayout()
    var delegate: MenuDelegate?
    var noteArray: [Notes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        view.backgroundColor = .purple
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    
    func getData() {
        
        NetworkManager.manager.resultType(archivedNotes: true) { result in
            switch result {
                
            case .success(let notes):
                self.updateCollectionView(notes: notes)
                
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    
    func updateCollectionView(notes: [Notes]) {
//        print("update")
        self.noteArray = notes
        print(noteArray.count)
        
        DispatchQueue.main.async {
            self.notesCollectioView.reloadData()
            
        }
    }
    
    
    
    func configureCollectionView() {
        //        let itemSize = UIScreen.main.bounds.width / 2 - 12
        
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 2
        //        layout.minimumInteritemSpacing = 2
        
        notesCollectioView.collectionViewLayout = layout
        notesCollectioView.backgroundColor = .clear
        notesCollectioView.delegate = self
        notesCollectioView.dataSource = self
        notesCollectioView.register(CollectionCell.self, forCellWithReuseIdentifier: "cells")
    }
    
    
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension ArchiveCollectionViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(noteArray.count)
        return noteArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cells", for: indexPath) as! CollectionCell
        
        let note = noteArray[indexPath.row]
        
        cell.titleLable.text = note.title
        cell.descriptionLabel.text = note.description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let addView = storyboard!.instantiateViewController(withIdentifier: "AddVC") as! AddViewController
        addView.isNew = false
        addView.note = noteArray[indexPath.row]
        addView.modalPresentationStyle = .fullScreen
        present(addView, animated: true, completion: nil)
    }
}


extension ArchiveCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 20, height : 150 )
    }
}
