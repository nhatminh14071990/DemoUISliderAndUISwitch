//
//  ViewController.swift
//  DemoUISliderAndUISwitch
//
//  Created by Van Ho Si on 9/25/17.
//  Copyright © 2017 Van Ho Si. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var switchRepeat: UISwitch!
    
    
    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var sliderTime: UISlider!
    
    
    
    var bombSoundEffect: AVAudioPlayer?
    let playImage: UIImage = UIImage(named: "play.png")!
    let pauseImage: UIImage = UIImage(named: "pause.png")!
    let thumbVolumeNormal = UIImage(named: "thumb.png")
    let thumbVolumeHightlight = UIImage(named: "thumbHightLight.png")
    let thumbDuration = UIImage(named: "duration.png")
    
    @IBOutlet weak var buttonPlay: UIButton!
    
    @IBOutlet weak var timeAudio: UISlider!
    
    @IBOutlet weak var currentAudioTime: UILabel!
    
    @IBOutlet weak var endAudioTime: UILabel!
    
    @IBAction func actionChangeTimeAudio(_ sender: UISlider) {
        bombSoundEffect?.currentTime = TimeInterval(sender.value)
        self.updateCurrentAudioTime()
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                     successfully flag: Bool){
        
        let isRepeat = switchRepeat.isOn
        if(!isRepeat){
            buttonPlay.setBackgroundImage(playImage, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "music.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do{
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.numberOfLoops = 0
            bombSoundEffect?.delegate = self;
            
            let audioDuration = bombSoundEffect?.duration ?? 0
            
            timeAudio.minimumValue = 0
            timeAudio.maximumValue = Float(audioDuration)
            timeAudio.value = 0
            endAudioTime.text = self.stringFromTimeInterval(interval: audioDuration)
            
            self.addThumdForSliderVolume()
            self.addThumbForSliderDuration()
            
        }catch{
            print("couldn't load file")
        }
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateCurrentAudioTime), userInfo: nil, repeats: true)
    }
    
    func addThumdForSliderVolume(){
        sliderVolume.setThumbImage(thumbVolumeNormal, for: .normal)
        sliderVolume.setThumbImage(thumbVolumeHightlight, for: .highlighted)
    }
    
    func addThumbForSliderDuration(){
        sliderTime.setThumbImage(thumbDuration, for: .normal)
    }

    @IBAction func actionAudioRepeat(_ sender: UISwitch) {
        if(sender.isOn){
            bombSoundEffect?.numberOfLoops = -1
        }else{
            bombSoundEffect?.numberOfLoops = 0
        }
    }
    
    @objc func updateCurrentAudioTime(){
        let audioCurrentTime = bombSoundEffect?.currentTime ?? 0
        currentAudioTime.text = self.stringFromTimeInterval(interval: audioCurrentTime)
        timeAudio.value = Float(audioCurrentTime)
        
        let audioDuration = bombSoundEffect?.duration ?? 0
        let timeLeftEnd = Float(audioDuration) - Float(audioCurrentTime)
        endAudioTime.text = self.stringFromTimeInterval(interval: TimeInterval(timeLeftEnd))
        
//        if(Int(audioCurrentTime) == Int(audioDuration)){
//            if(repeatAudio){
//
//                buttonPlay.setBackgroundImage(pauseImage, for: .normal)
//
//                self.delayWithSeconds(1) {
//                    self.bombSoundEffect?.play()
//                }
//            }else{
//                buttonPlay.setBackgroundImage(playImage, for: .normal)
//
//            }
//        }
        
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    @IBAction func actionPlayPause(_ sender: UIButton) {
        
        let isPlaying = bombSoundEffect?.isPlaying
        if(!(isPlaying)!){
            bombSoundEffect?.play()
            sender.setBackgroundImage(pauseImage, for: .normal)
            
        }else{
            bombSoundEffect?.pause()
            sender.setBackgroundImage(playImage, for: .normal)
            
        }
    }
    
    @IBAction func action_ChangeVolume(_ sender: UISlider) {
        let value = sender.value
        bombSoundEffect?.volume = value
    }
    
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = Int(interval)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if(ti > 3600){
            return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        }else{
            return String(format: "%0.2d:%0.2d", minutes, seconds)
        }
    }
}

