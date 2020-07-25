//
//  SelectionMenuCollectionViewController.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 6/24/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit

private let reuseIdentifier = "IconCell"

class SelectionMenuCollectionViewController: UICollectionViewController {
    
    var isIcon = Bool()
    var delegate: SelectionMenuCollectionViewControllerDelegate?
    
    //properties
    private let colorNames = ["Berry", "Blue", "Champagne", "Cyan", "Green", "Grey", "Haze", "LightGreen", "Orange", "Penny", "Pink", "Red", "Sage", "Sapphire", "SeaGreen"]
    private let numberOfItemPerRow: CGFloat = 2
    private let cellInset = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch isIcon {
        case true:
            return 50
        default:
            return colorNames.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SelectionMenuCollectionViewCell {
            
            if isIcon {
            cell.itemImageView.image = UIImage(named: "Object \(indexPath.row + 1)")
            } else {
                cell.itemImageView.backgroundColor = UIColor.init(named: colorNames[indexPath.row])
               
            }
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            return cell
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath.row
        
        if isIcon {
            delegate?.didSelect(true ,"Object \(index + 1)")
        } else {
            delegate?.didSelect(false, colorNames[index])
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Flow layout

extension SelectionMenuCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddSpace = cellInset.left * (numberOfItemPerRow + 1)
        let availableSpace = view.frame.width - paddSpace
        let widthPerItem = availableSpace / numberOfItemPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return cellInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellInset.left
    }
}


//MARK: - Delegate methods

protocol SelectionMenuCollectionViewControllerDelegate {
    
    func didSelect(_ isIconView: Bool, _ object: String)
}
