//
//  SwiftyTimerCell.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 5/5/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit

class SwiftyTimerCell: UICollectionViewCell {
    
    @IBOutlet var view: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    
    var cellWidth: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureText() {
        nameLabel.layer.shadowOffset = .init(width: 0, height: 3)
        nameLabel.layer.shadowColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        nameLabel.layer.shadowRadius = 2
        nameLabel.layer.shadowOpacity = 0.8
        
        durationLabel.layer.shadowOffset = .init(width: 0, height: 3)
        durationLabel.layer.shadowColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        durationLabel.layer.shadowRadius = 2
        durationLabel.layer.shadowOpacity = 0.8
    }
    
    func setConstraint() {
        if let cellWidth = cellWidth {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: cellWidth - 60).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: cellWidth - 60).isActive = true
            //imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
            
            durationLabel.translatesAutoresizingMaskIntoConstraints = false
            durationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            durationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        }
    }
}

