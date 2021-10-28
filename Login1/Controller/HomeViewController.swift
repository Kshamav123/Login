//
//  HomeViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 19/10/21.
//

import UIKit
import FirebaseFirestore



class HomeViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    
    var notesCollectioView: UICollectionView!
    
    
    
    var delegate : MenuDelegate?
    
    var noteArray :[Notes] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        title = "Home"
        configureNavigationBar()
        configureCollectionView()
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    
    func configureNavigationBar(){
        
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(handleMenu))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder.fill.badge.plus"), style: .done, target: self, action: #selector(addButtonHandle))
        
        
    }
    
    
    @objc func addButtonHandle(){
        
        
        print("button")
        
        //        let addViewController = AddViewController()
        //        addViewController.modalPresentationStyle = .fullScreen
        //        present(addViewController, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let addViewController = storyboard.instantiateViewController(withIdentifier: "AddVC") as? AddViewController
        addViewController?.modalPresentationStyle = .fullScreen
        addViewController?.isNew = true
        present(addViewController!,animated: true,completion: nil)
        print(noteArray)
        
    }
    
    
    @objc func handleMenu(){
        
        delegate?.menuHandler(index: -1)
        print(delegate)
        
    }
    
    func fetchData() {
        
        NetworkManager.manager.getNotes { notes in
            self.noteArray = notes
            DispatchQueue.main.async {
                self.notesCollectioView.reloadData()
            }
        }
        
    }
    

    
    
    func configureCollectionView() {
        
        notesCollectioView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(notesCollectioView)
        notesCollectioView.backgroundColor = .purple
        notesCollectioView.delegate = self
        notesCollectioView.dataSource = self
        notesCollectioView.backgroundColor = .purple
        notesCollectioView.register(CollectionCell.self, forCellWithReuseIdentifier: "cells")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addViewC = storyboard.instantiateViewController(withIdentifier: "AddVC") as! AddViewController
       
        addViewC.isNew = false
        addViewC.note = noteArray[indexPath.row]
        addViewC.modalPresentationStyle = .fullScreen
        present(addViewC,animated: true,completion: nil)
        
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 20) / 2
        return CGSize(width: width, height : 100 )
    }
    
}
