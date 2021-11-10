//
//  HomeViewController.swift
//  Login1
//
//  Created by Kshama Vidyananda on 19/10/21.
//

import UIKit
import FirebaseFirestore
import RealmSwift
import UserNotifications


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
        //        fetchNoteRealm()
        fetchData()
        //        scheduleTest()
        notesCollectioView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        fetchNoteRealm()
        hasMoreNotes = true
        fetchData()
        //       scheduleTest()
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
        print("====================\(addViewController)")
        present(addViewController!,animated: true,completion: nil)
        //        print(noteArray)
        
        print("YYYYYYYYYYYYYYYYYYYY")
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
    
    func updateUI(notes: [Notes]) {
        
        if notes.count < 10{
            self.hasMoreNotes = false
        }
        self.noteArray = notes
        DispatchQueue.main.async {
            self.notesCollectioView.reloadData()
        }
        
    }
    
    func fetchData() {
        
        NetworkManager.manager.resultType(archivedNotes: false) { result in
            print("FFFFFFFFFFFFFFFFFFFF")
//            print(self.noteArray.count)
            switch result {
                
            case .success(let notes) :
                self.updateUI(notes: notes)
//                print(self.noteArray.count)
                print("SSSSSSSSSSSSSSSSSSSSSS")
                
            case .failure(let error) :
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
        //        print(noteArray)
    }
    
    
    func fetchNoteRealm(){
        
        RealmManager.shared.fetchNotes { notesArray in
            self.notesRealm = notesArray
        }
        
    }
    
    
    func scheduleTest(){
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            
            for note in self.noteArray {
                
                let content = UNMutableNotificationContent()
                content.title = note.title
                content.sound = .default
                content.body = note.description
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: note.reminderTime!), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                    
                    if error != nil {
                        print("something went wrong")
                    }
                    
                })
            }
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
    
    
    
    //
    //            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //                return notesRealm.count
    //
    //            }
    //
    //            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cells", for: indexPath) as! CollectionCell
    //                let note = notesRealm[indexPath.row]
    //                cell.titleLable.text = note.title
    //                cell.descriptionLabel.text = note.description
    //
    //                return cell
    //            }
    //
    //            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //                let addViewC = storyboard.instantiateViewController(withIdentifier: "AddVC") as! AddViewController
    //
    //                addViewC.isNew = false
    //                addViewC.notesRealm = notesRealm[indexPath.row]
    //                addViewC.modalPresentationStyle = .fullScreen
    //                present(addViewC,animated: true,completion: nil)
    //
    //            }
    //
    
    
}

//MARK: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: width, height : 150 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 50.0, left: 1.0, bottom: 1.0, right: 1.0)
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
        
        return searching ? searchFilter.count : noteArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cells", for: indexPath) as! CollectionCell
        
        let note = searching ? searchFilter[indexPath.row] : noteArray[indexPath.row]
        cell.noteItem = note
        return cell
    }
    
}

//MARK : UICollectionViewDelegate

extension HomeViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addViewC = storyboard.instantiateViewController(withIdentifier: "AddVC") as! AddViewController
        addViewC.isNew = false
        addViewC.note = searching ? searchFilter[indexPath.row] : noteArray[indexPath.row]
        //        addViewC.notesRealm = notesRealm[indexPath.row]
        addViewC.modalPresentationStyle = .fullScreen
        present(addViewC,animated: true,completion: nil)
        
        
    }
}
