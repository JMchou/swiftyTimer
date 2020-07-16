//
//  TextViewController.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 7/15/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit
import WebKit

class TextViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        
        title = "Acknowledgement"
        navigationItem.titleView?.backgroundColor = .white
    
        let myUrl = URL(string: "https://www.apple.com")!
        let myRequest = URLRequest(url: myUrl)
        webView.load(myRequest)
    }
    
}
