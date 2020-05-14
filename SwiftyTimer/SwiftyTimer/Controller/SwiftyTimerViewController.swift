//
//  ViewController.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 5/5/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit

class SwiftyTimerViewController: UICollectionViewController {
    
    private let numberOfItemPerRow:CGFloat = 2
    private let cellInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private let cellIdentifier = "ItemCell"
    
    private var cellWidth: CGFloat?
    
    private var activities: [Activity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "SwiftyTimer"
        
        for position in 0...3 {
            let newActivity = Activity(name: "item \(position)", duration: 10, color: "green")
            activities.append(newActivity)
        }
    }
    

}

//MARK: - CollectionView Delegate and DataSource methods
extension SwiftyTimerViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let activity = activities[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SwiftyTimerCell
        cell.backgroundColor = UIColor(named: activity.color)
        cell.imageView.image = UIImage(named: activity.name)
        cell.layer.cornerRadius = 30
        if let cellWidth = self.cellWidth {
            cell.cellWidth = cellWidth
            cell.setConstraint()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let TimerVC = storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as? TimerViewController {
            TimerVC.activity = activities[indexPath.row]
            self.navigationController?.pushViewController(TimerVC, animated: true)
        }
    }
    
}


//MARK: - CollectionView Layout Delegate methods

extension SwiftyTimerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddSpace = cellInset.left * (numberOfItemPerRow + 1)
        let availableSpace = view.frame.width - paddSpace
        let widthPerItem = availableSpace / numberOfItemPerRow
        self.cellWidth = widthPerItem
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return cellInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellInset.left
    }
}
