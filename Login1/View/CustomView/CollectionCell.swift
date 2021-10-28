//
//  CollectionCell.swift
//  Login1
//
//  Created by Kshama Vidyananda on 27/10/21.
//

import Foundation
import UIKit

class CollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func configure() {
        print(":::::::::::::::::::::::::::::;;")
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        addSubview(titleLable)
        addSubview(descriptionLabel)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            titleLable.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            titleLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            //titleLable.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        
    }
}
