//
//  TimerViewController.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 5/6/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class TimerViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    //MARK: - Variables and properties
    private weak var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var remainingTime = 0
    private var countDownDuration = 0
    private var notificationIdentifier = ""
    private let itemManager = ItemManager.standard
    private var becameInactive = false
    
    private enum buttonImage {
        case StartButton
        case CancelButton
        case RestartButton
        case PauseButton
        case ResumeButton
        case ResetButton
        case MuteButton
        case RepeatButton
    }
    
    var activity: Item?
    var task = Task(state: .notStarted, timeCreated: Date(timeIntervalSinceNow: 0))
    
    //MARK: - UI configurations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.backgroundColor = UIColor.init(named: "TabBarColor")
        navigationItem.standardAppearance = barAppearance
        
        
        if let activity = activity {
            imageView.image = UIImage(named: activity.iconName!)
            view.backgroundColor = UIColor(named: activity.color!)
            self.title = activity.name
            self.remainingTime = activity.duration
            self.countDownDuration = activity.duration
        }
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(returnToHomePage))
        navigationItem.leftBarButtonItem = cancelButton
        
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(showDeleteAlert))
        navigationItem.rightBarButtonItem = deleteButton
        
        //Register notification
        NotificationCenter.default.addObserver(self, selector: #selector(becomeInactive), name: UIScene.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomesActive), name: UIScene.didActivateNotification, object: nil)
        
        //Start a timer that increments every second
        updateTimer()
    }
    
    @objc func returnToHomePage() {
        timer?.invalidate()
        stopSound()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showDeleteAlert() {
        let alert = UIAlertController(title: "Delete", message: "Are you user you want to delete this timer?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            if let toBeDeletedActivitiy = self.activity {
                self.timer?.invalidate()
                self.itemManager.deleteItem(item: toBeDeletedActivitiy)
            }
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    deinit {
        timer?.invalidate()
        stopSound()
    }
    //MARK: - IBActions
    
    @IBAction func buttonsPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            if task.state == .notStarted {
                self.navigationController?.popViewController(animated: true)
            } else if task.state == .completed {
                //Repeat Timer
                
                stopSound()
                resetTimer()
                creatTimer()
                task.updateState(with: .ongoing)
                leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.RestartButton)"), for: .normal)
                rightButton.setBackgroundImage(UIImage(named: "\(buttonImage.PauseButton)"), for: .normal)
            } else if task.state == .paused {
                //Reset Timer but don't start
                
                resetTimer()
                task.updateState(with: .notStarted)
                leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.CancelButton)"), for: .normal)
                rightButton.setBackgroundImage(UIImage(named: "\(buttonImage.StartButton)"), for: .normal)
            } else if task.state == .ongoing {
                resetTimer()
                creatTimer()
            }
        case 1:
            if task.state == .notStarted {
                //Start timer
                
                creatTimer()
                task.updateState(with: .ongoing)
                task.resetTime()
                sender.setBackgroundImage(UIImage(named: "\(buttonImage.PauseButton)"), for: .normal)
                leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.RestartButton)"), for: .normal)
            } else if task.state == .ongoing {
                //Pause timer
                
                timer?.invalidate()
                task.updateState(with: .paused)
                sender.setBackgroundImage(UIImage(named: "\(buttonImage.ResumeButton)"), for: .normal)
                leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.ResetButton)"), for: .normal)
            } else if task.state == .paused {
                //Resume Timer
                
                creatTimer()
                task.updateState(with: .ongoing)
                sender.setBackgroundImage(UIImage(named: "\(buttonImage.PauseButton)"), for: .normal)
                leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.RestartButton)"), for: .normal)
            } else if task.state == .completed {
                //Mute sound when timer is completed
                
                stopSound()
            }
        default:
            return
        }
    }
    
    func resetTimer() {
        if let activity = activity {
            timer?.invalidate()
            remainingTime = activity.duration
            task.resetTime()
            updateTimer()
        }
    }
}


//MARK: - Notification Methods

extension TimerViewController {
    
    @objc func becomeInactive() {
        //schedule local notification
        timer?.invalidate()
        self.becameInactive = true
        if task.state == .ongoing {
            notificationIdentifier = UUID().uuidString
            task.resetTime()
            
            let content = UNMutableNotificationContent()
            content.title = "Time's Up!"
            if let activity = activity {
                if let activityName = activity.name {
                    content.body = "Your \(activityName) timer has ended."
                }
            }
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "Alarm.wav"))
            
            let timeInterval = Double(remainingTime)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
            
            // add our notification request
            UNUserNotificationCenter.current().add(request)
        } else if task.state == .completed {
            stopSound()
        }
    }
    
    @objc func becomesActive() {
        //Resume timer
        guard task.state == .ongoing else { return }
        guard becameInactive else { return }
        
        //cancel local notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        
        let timeInterval = task.timeCreated.timeIntervalSinceNow
        let roundedTimeInterval = ceil(timeInterval)
        let intervalAsInt = Int(roundedTimeInterval) * -1
        
        if intervalAsInt <  remainingTime {
            self.remainingTime = remainingTime - intervalAsInt
            updateTimer()
            creatTimer()
        } else {
            remainingTime = 0
            task.updateState(with: .completed)
            updateTimer()
            leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.RepeatButton)"), for: .normal)
            rightButton.setBackgroundImage(UIImage(named: "\(buttonImage.MuteButton)"), for: .normal)
        }
        becameInactive = false
    }
}


//MARK: - Timer

extension TimerViewController {
    
    func creatTimer() {
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] (timer) in
            self?.updateTimer()
        }
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
    }
    
    func updateTimer() {
        if remainingTime == 0 && task.state != .completed {
            playSound()
            self.timer?.invalidate()
            task.updateState(with: .completed)
            leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.RepeatButton)"), for: .normal)
            rightButton.setBackgroundImage(UIImage(named: "\(buttonImage.MuteButton)"), for: .normal)
        }
        
        let hours = remainingTime / 3600
        let minutes = (remainingTime / 60) % 60
        let seconds =  remainingTime % 60
        
        var countDown = ""
        if hours > 0 {
            countDown += "\(hours):"
        }
        if minutes > 9 {
            countDown += "\(minutes):"
        } else {
            countDown += "0\(minutes):"
        }
        if seconds > 9 {
            countDown += "\(seconds)"
        } else {
            countDown += "0\(seconds)"
        }
        
        remainingTime -= 1
        countDownLabel.text = countDown
    }
    
}

//MARK: - Animation and sound

extension TimerViewController {
    
    func playSound() {
        let path = Bundle.main.path(forResource: "Alarm.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
            
        } catch {
            print("Could not find sound file.")
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }
}


