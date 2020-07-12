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
    private var timePassed = -1
    private var notificationIdentifier = ""
    
    private enum buttonImage {
        case CancelButton
        case PauseButton
        case ResumeButton
        case MuteButton
        case RepeatButton
    }
    
    var activity: Item?
    var task = Task(state: .ongoing, timeCreated: Date(timeIntervalSinceNow: 0))
    
    //MARK: - UI configurations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let activity = activity {
            imageView.image = UIImage(named: activity.iconName!)
            view.backgroundColor = UIColor(named: activity.color!)
        }
        
        //Register notification
        NotificationCenter.default.addObserver(self, selector: #selector(becomeInactive), name: UIScene.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomesActive), name: UIScene.willEnterForegroundNotification, object: nil)
        
        //Start a timer that increments every second
        updateTimer()
        creatTimer()
    }
    
    deinit {
        timer?.invalidate()
        stopSound()
    }
    //MARK: - IBActions
    
    @IBAction func buttonsPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            if task.state == .completed {
                leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.CancelButton)"), for: .normal)
                //leftButton.setTitle("Restart", for: .normal)
                
                rightButton.setBackgroundImage(UIImage(named: "\(buttonImage.PauseButton)"), for: .normal)
                //rightButton.setTitle("Pause", for: .normal)
                stopSound()
            }
            timePassed = -1
            timer?.invalidate()
            task.updateState(with: .ongoing)
            task.resetTime()
            creatTimer()
            updateTimer()
        case 1:
            if task.state == .ongoing {
                timer?.invalidate()
                timer = nil
                task.updateState(with: .paused)
                sender.setBackgroundImage(UIImage(named: "\(buttonImage.ResumeButton)"), for: .normal)
                //sender.setTitle("Resume", for: .normal)
            } else if task.state == .paused {
                creatTimer()
                task.updateState(with: .ongoing)
                sender.setBackgroundImage(UIImage(named: "\(buttonImage.PauseButton)"), for: .normal)
                //sender.setTitle("Pause", for: .normal)
            } else if task.state == .completed {
                stopSound()
//                soundTimer?.invalidate()
            }
        default:
            return
        }
    }
}


//MARK: - Notification Methods

extension TimerViewController {
    
    @objc func becomeInactive() {
        //schedule local notification
        timer?.invalidate()
        notificationIdentifier = UUID().uuidString
        
        guard let activity = activity else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Time's UP!"
        content.body = "You have completed your exercise."
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "Alarm.wav"))
        
        let remainingTime = Double(activity.duration - timePassed)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: remainingTime, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    @objc func becomesActive() {
        //cancel local notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        
        //Resume timer
        let timeInterval = task.timeCreated.timeIntervalSinceNow
        let roundedDate = ceil(timeInterval)
        let dateAsInt = Int(roundedDate) * -1
        
        if let activity = activity {
            if dateAsInt <  activity.duration {
                timePassed = (dateAsInt - 1)
                updateTimer()
                creatTimer()
            } else {
                timePassed = (activity.duration - 1)
                task.updateState(with: .completed)
                updateTimer()
            }
        }
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
        if let activity = activity {
            timePassed += 1
            
            if timePassed == activity.duration && task.state != .completed {
                self.timer?.invalidate()
                task.updateState(with: .completed)
                
                leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.RepeatButton)"), for: .normal)
                //leftButton.setTitle("Repeat", for: .normal)
                
                rightButton.setBackgroundImage(UIImage(named: "\(buttonImage.MuteButton)"), for: .normal)
                //rightButton.setTitle("Mute", for: .normal)
                
                playSound()
            }
            
            let currentTime = activity.duration - timePassed
            let hours = currentTime / 3600
            let minutes = (currentTime / 60) % 60
            let seconds =  currentTime % 60
            
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
            
            countDownLabel.text = countDown
        }
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

