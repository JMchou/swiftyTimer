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
    private enum status {
        case ongoing
        case paused
        case completed
    }
    private enum buttonImage {
        case cancelButton
        case pauseButton
        case resumeButton
        case muteButton
        case repeatButton
    }
    private var state = status.ongoing
    var activity: Activity?
    
    //MARK: - UI configurations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let activity = activity {
            imageView.image = UIImage(named: activity.name)
            view.backgroundColor = UIColor(named: activity.color)
        }
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
            if state == status.completed {
                leftButton.setBackgroundImage(UIImage(named: "\(buttonImage.cancelButton)"), for: .normal)
                leftButton.setTitle("Restart", for: .normal)
                
                rightButton.setBackgroundImage(UIImage(named: "\(buttonImage.pauseButton)"), for: .normal)
                rightButton.setTitle("Pause", for: .normal)
            }
            timePassed = -1
            soundTimer?.invalidate()
            timer?.invalidate()
            state = status.ongoing
            creatTimer()
            updateTimer()
        case 1:
            if state == status.ongoing {
                timer?.invalidate()
                timer = nil
                state = status.paused
                sender.setBackgroundImage(UIImage(named: "\(buttonImage.resumeButton)"), for: .normal)
                sender.setTitle("Resume", for: .normal)
            } else if state == status.paused {
                creatTimer()
                state = status.ongoing
                sender.setBackgroundImage(UIImage(named: "\(buttonImage.pauseButton)"), for: .normal)
                sender.setTitle("Pause", for: .normal)
            } else if state == status.completed {
                stopSound()
                soundTimer?.invalidate()
            }
        default:
            return
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
                state = status.completed
                
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
    
    //    func playAnimation() {
    //
    //        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
    //            self.imageView.transform = CGAffineTransform(rotationAngle: .pi/8)
    //        }) { (finished) in
    //            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
    //                self.imageView.transform = CGAffineTransform(rotationAngle: -(.pi/8))
    //            }) { (finished) in
    //                self.imageView.transform = CGAffineTransform.identity
    //            }
    //        }
    //    }
}
