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

class TimerCollectionViewController: UIViewController, SelectionMenuCollectionViewControllerDelegate {
    func didSelect(_ isIconView: Bool, _ object: String) {
        //do notthing
    }
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addButton: UIButton!
    
    private var displayLabel: UILabel!
    private var needJobImage: UIImageView!
    
    private let numberOfItemPerRow: CGFloat = 2
    private let cellInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private let cellIdentifier = "ItemCell"
    private let creationViewIdentifier = "CreationViewController"
    private var cellWidth: CGFloat?
    private var initialized: Bool = false
    
    
    private let items = ItemManager.standard.retrieveItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        self.title = "SwiftyTimer"
        
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
        emptylistLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 150).isActive = true
        
        
        let emptyListImage = UIImageView()
        needJobImage = emptyListImage
        emptyListImage.frame = CGRect(x: 0, y: 0, width: 200, height: 10)
        emptyListImage.image = UIImage(named: "NeedAJob")
        emptyListImage.contentMode = .scaleAspectFit
        self.view.addSubview(emptyListImage)
        
        emptyListImage.translatesAutoresizingMaskIntoConstraints = false
        emptyListImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4).isActive = true
        emptyListImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        emptyListImage.bottomAnchor.constraint(equalTo: emptylistLabel.topAnchor, constant: 0).isActive = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.init(named: "TabBarColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if items.count != 0 {
            displayLabel.alpha = 0
            needJobImage.alpha = 0
        } else {
            displayLabel.alpha = 1
            needJobImage.alpha = 1
        }
        
        collectionView.reloadData()
        let barAppearance = UINavigationBarAppearance()
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //present notification vc if the app is being launched for the first time.
        initialized = UserDefaults.standard.bool(forKey: "initialized")
        if !initialized {
            //do nothing yet
            UserDefaults.standard.set(true, forKey: "initialized")
            if let notificationVC = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
                notificationVC.modalPresentationStyle = .fullScreen
                present(notificationVC, animated: true)
            }
        }
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
            cell.nameLabel.text = activity.name
            cell.durationLabel.text = formatTime(duration: activity.duration)
//            cell.setConstraint()
            cell.configureText()
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
    
    
    func formatTime(duration: Int) -> String {
        
        let hours = duration / 3600
        let minutes = (duration / 60) % 60
        let seconds =  duration % 60
        
        var countDown = ""
        if hours > 0 {
            countDown += "\(hours) : "
        }
        if minutes > 9 {
            countDown += "\(minutes) : "
        } else {
            countDown += "0\(minutes) : "
        }
        if seconds > 9 {
            countDown += "\(seconds)"
        } else {
            countDown += "0\(seconds)"
        }
        
        return countDown
    }
    
}


//MARK: - CollectionView Layout Delegate methods

extension TimerCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddSpace = cellInset.left * (numberOfItemPerRow + 1)
        let availableSpace = view.frame.width - paddSpace
        let widthPerItem = availableSpace / numberOfItemPerRow
        self.cellWidth = widthPerItem
        
        return CGSize(width: widthPerItem, height: widthPerItem + 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return cellInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellInset.left
    }
}
