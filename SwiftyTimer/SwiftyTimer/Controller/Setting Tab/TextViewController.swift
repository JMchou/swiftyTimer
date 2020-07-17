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
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        
        if let filepath = Bundle.main.path(forResource: "acknowledgement", ofType: "html") {
            do {
                let contents = try String(contentsOfFile: filepath)
                
                let htmlData = NSString(string: contents).data(using: String.Encoding.utf8.rawValue)
                
                let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                
                let attributedString = try! NSAttributedString(data: htmlData!,
                                                               options: options, documentAttributes: nil)
                
                textView.attributedText = attributedString
            } catch {
                print("failed to retrieve acknowledgement document \(error)")
            }
        }
        
        
    }
    
}
