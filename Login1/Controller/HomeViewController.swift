//
//  HomeViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 19/10/21.
//

import UIKit
import FirebaseFirestore
import RealmSwift



class HomeViewController: UIViewController  {
    
    //MARK :- Properties
    
    var notesCollectioView: UICollectionView!
    var flag = true
    var delegate : MenuDelegate?
    var toggleButton = UIBarButtonItem()
    var noteArray :[Notes] = []
    var notesRealm :[NotesRealm] = []
    var searchFilter = [Notes]()
    var searching = false
    var hasMoreNotes = true
    var width: CGFloat = 0
    
    let collection = UICollectionViewFlowLayout()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK :- Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = (view.frame.width - 20)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        configureNavigationBar()
        
        configureSearchController()
        configureCollectionView()
        fetchNoteRealm()
        fetchData()
        notesCollectioView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNoteRealm()
        hasMoreNotes = true
        fetchData()
        notesCollectioView.reloadData()
    }
    
    
    //MARK :- Actions
    
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
        //        print(noteArray)
        
    }
    
    @objc func handleMenu(){
        
        delegate?.menuHandler(index: -1)
        print(delegate)
        
    }
    
    //MARK :- Helper
    
    func configureNavigationBar(){
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "Home"
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        //        searchBar.delegate = self
        //        searchBar.placeholder = "Search"
        //        searchBar.searchTextField.textColor = .white
        //        searchBar.barTintColor = .white
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "folder.fill.badge.plus"), style: .done, target: self, action: #selector(addButtonHandle))
        
        toggleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.below.rectangle"), style: .done, target: self, action: #selector(toggleButtonTapped))
        
        //        let searchBar = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))
        //            searchBar.sizeToFit()
        //        navigationItem.rightBarButtonItems = [addButton, toggleButton, searchBar]
        
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(handleMenu))
        
        let sideMenuBar = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(handleMenu))
        navigationItem.leftBarButtonItems = [sideMenuBar, toggleButton, addButton]
        
        //        navigationItem.rightBarButtonItems = [searchBar]
        
        //        showSearchBarButton(shouldShow: true)
    }
    
    func configureCollectionView() {
        
        notesCollectioView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(notesCollectioView)
        notesCollectioView.delegate = self
        notesCollectioView.dataSource = self
        notesCollectioView.backgroundColor = .purple
        notesCollectioView.register(CollectionCell.self, forCellWithReuseIdentifier: "cells")
    }
    

    func fetchData() {
        
        NetworkManager.manager.fetchNotesToPagenate { notes in
            if notes.count < 10{
                self.hasMoreNotes = false
            }
            self.noteArray = notes
            DispatchQueue.main.async {
                self.notesCollectioView.reloadData()
            }
        }
        
    }
    
    func fetchNoteRealm(){
        
        RealmManager.shared.fetchNotes { notesArray in
            self.notesRealm = notesArray
        }

    }
    
    func configureSearchController(){
        
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    

    
    //        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //            return notesRealm.count
    //
    //        }
    //
    //        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cells", for: indexPath) as! CollectionCell
    //            let note = notesRealm[indexPath.row]
    //            cell.titleLable.text = note.title
    //            cell.descriptionLabel.text = note.description
    //
    //            return cell
    //        }
    //
    //        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //            let addViewC = storyboard.instantiateViewController(withIdentifier: "AddVC") as! AddViewController
    //
    //            addViewC.isNew = false
    //            addViewC.notesRealm = notesRealm[indexPath.row]
    //            addViewC.modalPresentationStyle = .fullScreen
    //            present(addViewC,animated: true,completion: nil)
    //
    //        }
    
    
    
}

//MARK: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: width, height : 100 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
   
}

//MARK : UISearchResultsUpdating, UISearchBarDelegate

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate{
    
    func updateSearchResults( for searchController: UISearchController){
        let count = searchController.searchBar.text?.count
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty{
            
            searching = true
            searchFilter.removeAll()
            searchFilter = noteArray.filter({$0.title.prefix(count!).lowercased() == searchText.lowercased()})
            print("for")
            
        } else {
            print("else")
            searching = false
            searchFilter.removeAll()
            searchFilter = noteArray
        }
        notesCollectioView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searching = false
        searchFilter.removeAll()
        notesCollectioView.reloadData()
        
    }
}

//MARK : UIScrollViewDelegate

extension HomeViewController : UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        if position > notesCollectioView.contentSize.height-scrollView.frame.height-100 {
            print("**********************************")
            guard hasMoreNotes else {return}
            guard !isLoadingMoreNotes else {
                
                print("+++++++++++++++++++++++")
                return
            }
            
            NetworkManager.manager.fetchMoreNotesToPagenate { notes in
                if notes.count < 10{
                    print(":::::::::::::::::::::")
                    self.hasMoreNotes = false
                }
                
                self.noteArray.append(contentsOf: notes)
//                self.searchFilter = self.noteArray
                self.notesCollectioView.reloadData()
            }
        }
        
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//
//        let position = scrollView.contentOffset.y
//        if position > notesCollectioView.contentSize.height-scrollView.frame.height-100 {
//            guard hasMoreNotes else {return}
//            guard !isLoadingMoreNotes else {
//
//                print("+++++++++++++++++++++++")
//                return
//            }
//
//            NetworkManager.manager.fetchMoreNotesToPagenate { notes in
//                if notes.count < 10{
//                    print(":::::::::::::::::::::")
//                    self.hasMoreNotes = false
//                }
//
//                self.noteArray.append(contentsOf: notes)
////                self.searchFilter = self.noteArray
//                self.notesCollectioView.reloadData()
//            }
//        }
//    }
}

//MARK : UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searching{
            return searchFilter.count
        }else{
            return noteArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if searching {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cells", for: indexPath) as! CollectionCell
            let note = searchFilter[indexPath.row]
            cell.noteItem = note
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cells", for: indexPath) as! CollectionCell
            let note = noteArray[indexPath.row]
            cell.noteItem = note
            return cell
        }
    }
    
    
}

//MARK : UICollectionViewDelegate

extension HomeViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searching {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addViewC = storyboard.instantiateViewController(withIdentifier: "AddVC") as! AddViewController
            
            addViewC.isNew = false
            addViewC.note = searchFilter[indexPath.row]
            addViewC.notesRealm = notesRealm[indexPath.row]
            addViewC.modalPresentationStyle = .fullScreen
            present(addViewC,animated: true,completion: nil)
        } else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addViewC = storyboard.instantiateViewController(withIdentifier: "AddVC") as! AddViewController
            
            addViewC.isNew = false
            addViewC.note = noteArray[indexPath.row]
            addViewC.notesRealm = notesRealm[indexPath.row]
            addViewC.modalPresentationStyle = .fullScreen
            present(addViewC,animated: true,completion: nil)
        }
        
    }
}
