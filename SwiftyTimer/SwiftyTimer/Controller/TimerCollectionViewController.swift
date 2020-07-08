//
//  TimerCollectionViewController.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 7/5/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class TimerCollectionViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addButton: UIButton!
    
    private var displayLabel: UILabel!
    
    private let numberOfItemPerRow: CGFloat = 2
    private let cellInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private let cellIdentifier = "ItemCell"
    private let creationViewIdentifier = "CreationViewController"
    private var cellWidth: CGFloat?
    
    private let items = ItemManager.standard.retrieveItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        self.title = "SwiftyTimers"
        
        let emptylistLabel = UILabel()
        displayLabel = emptylistLabel
        emptylistLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        emptylistLabel.numberOfLines = 0
        emptylistLabel.text = "You currently don't have any timer created yet. It's time to put me to work!"
        emptylistLabel.textColor = UIColor.lightGray
        emptylistLabel.alpha = 0.7
        emptylistLabel.textAlignment = .center
        self.view.addSubview(emptylistLabel)
        
        emptylistLabel.translatesAutoresizingMaskIntoConstraints = false
        emptylistLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        emptylistLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        emptylistLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 100).isActive = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.init(named: "TabBarColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                // do nothing yet
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if items.count != 0 {
            displayLabel.alpha = 0
        } else {
            displayLabel.alpha = 1
        }
        
        collectionView.reloadData()
        let barAppearance = UINavigationBarAppearance()
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    //MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let creationVC = storyboard?.instantiateViewController(withIdentifier: creationViewIdentifier) as? CreationViewController {
//            navigationController?.pushViewController(creationVC, animated: true)
            creationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(creationVC, animated: true)
        }
        
    }
}



//MARK: - CollectionView Delegate and DataSource methods
extension TimerCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //            return activities.count
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let activity = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SwiftyTimerCell
        cell.backgroundColor = UIColor(named: activity.color!)
        cell.imageView.image = UIImage(named: activity.iconName!)
        cell.layer.cornerRadius = 30
        if let cellWidth = self.cellWidth {
            cell.cellWidth = cellWidth
            cell.setConstraint()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let TimerVC = storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as? TimerViewController {
            TimerVC.activity = items[indexPath.row]
            TimerVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(TimerVC, animated: true)
        }
    }
    
    
}


//MARK: - CollectionView Layout Delegate methods

extension TimerCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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
