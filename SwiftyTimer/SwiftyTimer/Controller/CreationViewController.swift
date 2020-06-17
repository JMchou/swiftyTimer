//
//  CreationViewController.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 6/3/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {
    
    //Outlets, variables, and properties
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var durationView: UILabel!
    @IBOutlet var iconView: UIButton!
    @IBOutlet var nameTextField: UITextFieldPadding!
    @IBOutlet var colorButton: UIButton!
    
    private var hours: String = "00"
    private var minutes: String = "00"
    private var seconds: String = "00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        nameTextField.delegate = self
        
        let tab = UITapGestureRecognizer(target: self.view, action: #selector(nameTextField.endEditing(_:)))
        view.addGestureRecognizer(tab)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveViewUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveViewBack(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finishedAddingItem))
        navigationItem.rightBarButtonItem = doneButton
        
        // Do any additional setup after loading the view
        configureViews()
    }
    
    @objc private func finishedAddingItem() {
        //Persist new item to local storage.
        
    }
    
    @objc private func moveViewUp(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let visibleView = view.bounds.height - keyboardSize.height
        if (durationView.frame.maxY > visibleView) {
            let moveDistance = durationView.frame.maxY - visibleView + 10
            self.view.frame.origin.y = 0 - moveDistance
        }
    }
    
    @objc private func moveViewBack(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
}

//MARK: - PickerView delegate and datasource methods

extension CreationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 60
        case 2:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerView = UILabel()
        pickerView.textAlignment = .center
        pickerView.font = UIFont.systemFont(ofSize: 24)
        pickerView.textColor = UIColor.white
        pickerView.text = "\(row)"
        return pickerView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            if row < 9 {
                hours  = "0\(row)"
            } else {
                hours = "\(row)"
            }
        case 1:
            if row < 9 {
                minutes  = "0\(row)"
            } else {
                minutes = "\(row)"
            }
        case 2:
            if row < 9 {
                seconds  = "0\(row)"
            } else {
                seconds = "\(row)"
            }
        default:
            return
        }
        
        durationView.text = hours + " hrs : " + minutes + " min : " + seconds + " sec"
    }
}

//MARK: - Textfield delegate methods

extension CreationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}

//MARK: - View elements and layout constraints

extension CreationViewController {
    
    func configureViews() {
        nameTextField.borderStyle =  .none
        nameTextField.textAlignment = .natural
        nameTextField.layer.cornerRadius = 10
        
        durationView.layer.masksToBounds = true
        durationView.layer.cornerRadius = 10
        
        colorButton.layer.masksToBounds = true
        colorButton.layer.cornerRadius = 10
        
        iconView.layoutIfNeeded()
        let iconSize = iconView.frame.size.width
        iconView.layer.cornerRadius = iconSize/2
        
        let labelView = UILabel()
        labelView.text = "min"
        labelView.textColor = .white
        labelView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.addSubview(labelView)
        
        let hourView = UILabel()
        hourView.text = "hours"
        hourView.textColor = .white
        hourView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hourView)
        
        let secView = UILabel()
        secView.text = "sec"
        secView.textColor = .white
        secView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secView)
        
        let widthSize = view.frame.size.width
        var minOffset: CGFloat = 0.0
        var hourOffset: CGFloat = 0.0
        var secOffset: CGFloat = 0.0
        var heightOffset: CGFloat = 0.0
        
        switch widthSize {
        case  375.0:
            minOffset = (widthSize/100) * 29
            hourOffset = (widthSize/100) * 54
            secOffset = (widthSize/100) * 1
            heightOffset = -150.0
        default:
            minOffset = (widthSize/100) * 31
            hourOffset = (widthSize/100) * 56
            secOffset = (widthSize/100) * 2
            heightOffset = -174.0
        }
        
        let layoutConstraints: [NSLayoutConstraint] = [
            
            
            labelView.trailingAnchor.constraint(equalTo: self.pickerView.trailingAnchor,
                                                constant: -minOffset),
            labelView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOffset),
            
            hourView.trailingAnchor.constraint(equalTo: self.pickerView.trailingAnchor, constant: -hourOffset),
            hourView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOffset),
            
            secView.trailingAnchor.constraint(equalTo: self.pickerView.trailingAnchor, constant: -secOffset),
            secView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOffset)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
        
    }
}
