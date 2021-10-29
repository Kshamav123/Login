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
    var flag = true
    var delegate : MenuDelegate?
    var toggleButton = UIBarButtonItem()
    var noteArray :[Notes] = []
    
    let collection = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        title = "Home"
        width = (view.frame.width - 20)
        configureNavigationBar()
        configureCollectionView()
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    
    func configureNavigationBar(){
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "folder.fill.badge.plus"), style: .done, target: self, action: #selector(addButtonHandle))
        
        toggleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.below.rectangle"), style: .done, target: self, action: #selector(toggleButtonTapped))
        
        navigationItem.rightBarButtonItems = [addButton, toggleButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(handleMenu))
        
        
        //   list.bullet.below.rectangle
        //  square.grid.2x2
        
    }
    
    var width: CGFloat = 0
    
    @objc func toggleButtonTapped(){
        
        if !flag {
            flag = !flag
            width = (view.frame.width - 20)
            toggleButton.image = UIImage(systemName: "list.bullet.below.rectangle")
            
        }else {
            
            flag = !flag
            width = (view.frame.width - 20) / 2
            toggleButton.image = UIImage(systemName: "square.grid.2x2")
            
        }
        notesCollectioView.reloadData()
        
    }
    
    
    @objc func addButtonHandle(){
        
        
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
        
        return CGSize(width: width, height : 100 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 50.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
}
