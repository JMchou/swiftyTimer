//
//  TimerViewController.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 5/6/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    //MARK: - Variables and properties
    private weak var timer: Timer?
    private weak var soundTimer: Timer?
    private var timePassed = -1
    
    private enum buttonImage {
        case cancelButton
        case pauseButton
        case resumeButton
        case muteButton
        case repeatButton
    }
    
    var activity: Activity?
    var task = Task(state: .ongoing, timeCreated: Date(timeIntervalSinceNow: 0))
    
    //MARK: - UI configurations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let activity = activity {
            imageView.image = UIImage(named: activity.name)
            view.backgroundColor = UIColor(named: activity.color)
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
        soundTimer?.invalidate()
    }
    //MARK: - IBActions
    
    @IBAction func buttonsPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            if task.state == .completed {
                leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.cancelButton)"), for: .normal)
                leftButton.setTitle("Restart", for: .normal)
                
                rightButton.setBackgroundImage(UIImage(named: "\(buttonImage.pauseButton)"), for: .normal)
                rightButton.setTitle("Pause", for: .normal)
            }
            timePassed = -1
            soundTimer?.invalidate()
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
                sender.setBackgroundImage(UIImage(named: "\(buttonImage.resumeButton)"), for: .normal)
                sender.setTitle("Resume", for: .normal)
            } else if task.state == .paused {
                creatTimer()
                task.updateState(with: .ongoing)
                sender.setBackgroundImage(UIImage(named: "\(buttonImage.pauseButton)"), for: .normal)
                sender.setTitle("Pause", for: .normal)
            } else if task.state == .completed {
                stopSound()
                soundTimer?.invalidate()
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
        print("I've become inactive")
    }
    
    @objc func becomesActive() {
        //cancel local notification
        print("I've become active")
        //Resume since the time that has passed.
        
        let timeInterval = task.timeCreated.timeIntervalSinceNow
        let roundedDate = ceil(timeInterval)
        let dateAsInt = Int(roundedDate) * -1
        
        
        if let activity = activity {
            if dateAsInt <  activity.duration {
                timePassed = (dateAsInt - 1)
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
    
    func creatSoundTimer() {
        let soundTimer = Timer(timeInterval: 3, repeats: true) { [weak self] (timer) in
            self?.playSound()
        }
        RunLoop.current.add(soundTimer, forMode: .common)
        self.soundTimer = soundTimer
    }
    
    func updateTimer() {
        if let activity = activity {
            timePassed += 1
            
            if timePassed == activity.duration {
                self.timer?.invalidate()
                task.updateState(with: .completed)
                
                leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.repeatButton)"), for: .normal)
                leftButton.setTitle("Repeat", for: .normal)
                
                rightButton.setBackgroundImage(UIImage(named: "\(buttonImage.muteButton)"), for: .normal)
                rightButton.setTitle("Mute", for: .normal)
                
                playSound()
                creatSoundTimer()
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
        let systemSoundID: SystemSoundID =  1304
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func stopSound() {
        AudioServicesDisposeSystemSoundID(1304)
    }
}

