//
//  CollectionCell.swift
//  Login1
//
//  Created by Kshama Vidyananda on 27/10/21.
//

import Foundation
import UIKit

class CollectionCell: UICollectionViewCell {
//    var cellButton: UIButton!
    var noteItem : Notes? {
        
        didSet{
            titleLable.text = noteItem?.title
            descriptionLabel.text = noteItem?.description
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
//        cellButton = UIButton(frame: CGRect(x: 5, y: 5, width: 20, height: 30))
//        addSubview(cellButton)
        configure()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
//        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var descriptionLabel:  UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 18)
        label.backgroundColor = .systemBackground
        label.isScrollEnabled = false
        label.isEditable = false
        return label
    }()
    
//    var archiveButton: UIButton = {

//        let button = UIButton()
//        let image = UIImage(systemName: "folder.fill.badge.plus")
//        button.frame = CGRect(x: 200, y: 400, width: 52, height: 52)
//        button.setTitle("Archive", for: .normal)
//        button.layer.borderWidth = 1.0
//        button.layer.borderColor = UIColor.black.cgColor
//        button.layer.cornerRadius = 25
//        button.titleLabel?.textColor = UIColor.black
//        button.setTitleColor(UIColor.black, for: .normal)
//        button.setImage(image, for: .normal)
//        button.addTarget(self, action: #selector(archiveButtonHandle), for: .touchUpInside)
//        return button
//    }()
    
//    var reminderButton: UIButton = {
//
//        let button = UIButton()
//
//        return button
//
//
//    }()
    
    
//  @objc func archiveButtonHandle() {
//
//      print("archive")
//    }
    
    func configure() {
       
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.purple.cgColor
        addSubview(titleLable)
        addSubview(descriptionLabel)
//        addSubview(archiveButton)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        archiveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleLable.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            titleLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            //titleLable.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -150),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
//            cellButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 100),
//            cellButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 50),
//            archiveButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
//            archiveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
//            archiveButton.heightAnchor.constraint(equalToConstant: 50),
//            archiveButton.widthAnchor.constraint(equalToConstant: 50)
            
        ])
        
        
    }
}
