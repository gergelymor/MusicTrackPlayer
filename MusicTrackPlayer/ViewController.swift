//
//  ViewController.swift
//  MusicTrackPlayer
//
//  Created by Greg Mor Bacskai on 22/10/16.
//  Copyright © 2016 bacskai. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player = AVAudioPlayer()
    let audioPath = Bundle.main.path(forResource: "JudasPriest", ofType: "mp3")
    var timer = Timer()

    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    func updateProgress(){
        progressSlider.value = Float(player.currentTime)
        progressLabel.text = "Progress: \(getTimeValue())"
    }
    
    func getTimeValue() -> String{
        let currentTime = Int(player.currentTime)
        if currentTime < 60{
            if currentTime < 10{
                return "00:0\(currentTime)"
            }
            return "00:\(currentTime)"
        }
        else{
            let minutes = currentTime / 60
            let seconds = currentTime % 60
            if minutes < 10{
                if seconds < 10{
                    return "0\(minutes):0\(seconds)"
                }
                else{
                    return "0\(minutes):\(seconds)"
                }
            }
            else{
                return "\(minutes):\(seconds)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            progressSlider.maximumValue = Float(player.duration)
            
            try AVAudioSession.sharedInstance().setActive(true)
            player.volume = AVAudioSession.sharedInstance().outputVolume
            volumeSlider.value = player.volume
            volumeLabel.text = "Volume: \(Int(player.volume*100))%"
            progressLabel.text = "Progress: 00:00"
        }
        catch{
            print(error.localizedDescription)
        }
    }

    @IBAction func playPressed(_ sender: AnyObject) {
        player.play()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateProgress), userInfo: nil, repeats: true)
    }
    
    @IBAction func pausePressed(_ sender: AnyObject) {
        player.pause()
    }
    
    @IBAction func stopPressed(_ sender: AnyObject) {
        do{
            timer.invalidate()
            player.pause()
            progressSlider.value = 0
            progressLabel.text = "Progress: 00:00"
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func volumeChanged(_ sender: AnyObject) {
        player.volume = volumeSlider.value
        volumeLabel.text = "Volume: \(Int(player.volume*100))%"
    }

    @IBAction func progressChanged(_ sender: AnyObject) {
        player.currentTime = TimeInterval(progressSlider.value)
        progressLabel.text = "Progress: \(getTimeValue())"
    }
    
}

