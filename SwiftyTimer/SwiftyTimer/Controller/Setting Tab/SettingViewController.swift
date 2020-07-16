//
//  SettingViewController.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 7/6/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AcknowledgementPressed(_ sender: UIButton) {
        
        if let textVC = storyboard?.instantiateViewController(identifier: "TextViewController") as? TextViewController {
            textVC.hidesBottomBarWhenPushed = true
            textVC.view.backgroundColor = UIColor.init(named: "Background")
            self.navigationController?.pushViewController(textVC, animated: true)
        }
        
    }
    
}
