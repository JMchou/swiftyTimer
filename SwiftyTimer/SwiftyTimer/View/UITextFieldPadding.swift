//
//  UITextFieldPadding.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 6/12/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit

class UITextFieldPadding: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let placeHolderString = NSAttributedString(string: "name of the activity", attributes: [.foregroundColor: UIColor.lightText, .font: UIFont.systemFont(ofSize: 18, weight: .ultraLight)])
        self.attributedPlaceholder = placeHolderString
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
