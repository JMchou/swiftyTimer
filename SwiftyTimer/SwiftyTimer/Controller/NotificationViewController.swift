//
//  NotificationViewController.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 7/11/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit
import NotificationCenter

class NotificationViewController: UIViewController {

    @IBOutlet var allowButton: UIButton!
    @IBOutlet var laterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allowButton.layer.cornerRadius = 10
        laterButton.layer.cornerRadius = 10
    }
    
    @IBAction func allowButtonPressed(_ sender: UIButton) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
       
    }
    
    @IBAction func laterButtonPressed(_ sender: UIButton) {
        
        presentAlert()
    }
    
    func presentAlert() {
        let title = "Alert"
        let message = "Beware disabling notificaiton will cause the App to only work partially. You can always enable it later in the phone's setting page."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Enable now", style: .default, handler: nil))
    
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
