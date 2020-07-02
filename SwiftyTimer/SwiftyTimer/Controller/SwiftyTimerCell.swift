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
    
    var cellWidth: CGFloat?
    
    func setConstraint() {
        if let cellWidth = cellWidth {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: cellWidth-30).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: cellWidth-30).isActive = true
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
}

