//
//  CreationViewController.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 6/3/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit
import RealmSwift

class CreationViewController: UIViewController {
    
    //Outlets, variables, and properties
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var durationView: UILabel!
    @IBOutlet var iconView: UIButton!
    @IBOutlet var nameTextField: UITextFieldPadding!
    @IBOutlet var colorButton: UIButton!
    @IBOutlet var stackView: UIStackView!
    
    private var hours: String = "00"
    private var minutes: String = "00"
    private var seconds: String = "00"
    private var activityColor: String = "Blue"
    private var activityIcon: String?
    private let itemManager = ItemManager.standard
    
    override func viewDidLayoutSubviews() {

       let iconSize = iconView.frame.size.width
       iconView.layer.cornerRadius = iconSize/2
               
    }
    
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
    
    //MARK: - IBActions
    
    
    @IBAction func iconPressed(_ sender: UIButton) {
        /*
         Present a view controller that displays all the availble
         icons for the user to choose.
         */
        
        if let selectionViewController = storyboard?.instantiateViewController(identifier: "SelectionMenuCollectionViewController") as? SelectionMenuCollectionViewController {
            
            selectionViewController.isIcon = true
            selectionViewController.delegate = self
            present(selectionViewController, animated: true)
        }
    }
    
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        
        //Similar to iconPressed, but it displays all the available colors instead
        if let selectionViewController = storyboard?.instantiateViewController(identifier: "SelectionMenuCollectionViewController") as? SelectionMenuCollectionViewController {
            
            selectionViewController.isIcon = false
            selectionViewController.delegate = self
            present(selectionViewController, animated: true)
        }
    }
    
    //MARK: - Selector functions
    
    @objc private func finishedAddingItem() {
        //Persist new item to local storage.
        let duration = convertStringToIntDuraction()
        guard duration > 0 else { return }
        guard let name = nameTextField.text else { return }
        guard let icon = activityIcon else { return }
        
        itemManager.createItem(name: name, iconName: icon, duration: duration, Color: self.activityColor)
        navigationController?.popViewController(animated: true)
    }
    
    func convertStringToIntDuraction() -> Int {
        let secInInt = Int(seconds) ?? 0
        let minInInt = Int(minutes) ?? 0
        let hrsInInt = Int(hours) ?? 0
        
        let totalDuration = (secInInt) + (minInInt * 60) + (hrsInInt * 3600)
        return totalDuration
    }
    
    //Move the view up and down depending on the keyboard's hidden status
    
    @objc private func moveViewUp(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let visibleView = view.bounds.height - keyboardSize.height
        if (stackView.frame.maxY > visibleView) {
            let moveDistance = stackView.frame.maxY - visibleView + 10
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
            hourOffset = (widthSize/100) * 53
            secOffset = (widthSize/100) * 1
            heightOffset = -pickerView.bounds.height * 0.43
        default:
            minOffset = (widthSize/100) * 31
            hourOffset = (widthSize/100) * 55
            secOffset = (widthSize/100) * 2
            heightOffset = -pickerView.bounds.height * 0.43
        }
        
        let layoutConstraints: [NSLayoutConstraint] = [
            
            
            labelView.trailingAnchor.constraint(equalTo: self.pickerView.trailingAnchor,
                                                constant: -minOffset),
            labelView.bottomAnchor.constraint(equalTo: self.pickerView.bottomAnchor, constant: heightOffset),
            
            hourView.trailingAnchor.constraint(equalTo: self.pickerView.trailingAnchor, constant: -hourOffset),
            hourView.bottomAnchor.constraint(equalTo: self.pickerView.bottomAnchor, constant: heightOffset),
            
            secView.trailingAnchor.constraint(equalTo: self.pickerView.trailingAnchor, constant: -secOffset),
            secView.bottomAnchor.constraint(equalTo: self.pickerView.bottomAnchor, constant: heightOffset)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
        
    }
}

//MARK: - SelectionMenuCollectionView delegate methods

extension CreationViewController: SelectionMenuCollectionViewControllerDelegate {
    
    func didSelect(_ isIconView: Bool, _ object: String) {
        
        if isIconView {
            iconView.setImage(UIImage(named: object), for: .normal)
            activityIcon = object
        } else {
            colorButton.backgroundColor = UIColor.init(named: object)
            iconView.backgroundColor = UIColor.init(named: object)
            activityColor = object
        }
    }
}
