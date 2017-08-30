//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Ryan Stoppler on 2017-04-06.
//  Copyright © 2017 stoppler. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, UIPickerViewDelegate{

    //variables
    @IBOutlet weak var trackTitle   : UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backButton   : UIButton!
    @IBOutlet weak var fastButton   : UIButton!
    @IBOutlet weak var normalButton : UIButton!
    @IBOutlet weak var slowButton   : UIButton!
    @IBOutlet weak var resetButton  : UIButton!
    @IBOutlet weak var playButton   : UIButton!
    @IBOutlet weak var songPicker   : UIPickerView!
    @IBOutlet weak var timeLeft     : UILabel!
    @IBOutlet weak var timeSlider   : UISlider!
    @IBOutlet weak var playedTime   : UILabel!
    var timer                       : Timer!
    var audioPlayer = AVAudioPlayer()
    var isPlaying   = false
    var songChosen  = "Take A Chance On Me"
    let pickerData  = ["Take A Chance On Me", "Re_ Your Brains", "I Wanna Be Sedated", "New Math"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.songPicker.delegate = self
        //load currently selected song and prepare to play
        beginSong()
        styleButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //play or pause music
    @IBAction func playOrPauseMusic(_ sender: Any) {
        if isPlaying{
            audioPlayer.pause()
            isPlaying = false
        }else{
            speak()
            audioPlayer.play()
            isPlaying = true
            timer     = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
            timer     = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.timeRemaining), userInfo: nil, repeats: true)
            timer     = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateScrub), userInfo: nil, repeats: true)
        }
    }
    //initialize song to be played
    func beginSong(){
        trackTitle.text = songChosen
        let path = Bundle.main.url(forResource: songChosen, withExtension: "mp3")
        //var error:NSError?
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: path!)
            timeSlider.maximumValue = Float(audioPlayer.duration)
            audioPlayer.enableRate = true
            
        }catch{
            //error
        }
    }
    
    //style buttons
    func styleButtons(){
        
        //play button
        playButton.layer.cornerRadius    = 5
        playButton.layer.borderWidth     = 1
        playButton.layer.borderColor     = UIColor.black.cgColor
        
        //reset button
        resetButton.layer.cornerRadius   = 5
        resetButton.layer.borderWidth    = 1
        resetButton.layer.borderColor    = UIColor.black.cgColor
        
        //slow button
        slowButton.layer.cornerRadius    = 5
        slowButton.layer.borderWidth     = 1
        slowButton.layer.borderColor     = UIColor.black.cgColor
        
        //normal button
        normalButton.layer.cornerRadius  = 5
        normalButton.layer.borderWidth   = 1
        normalButton.layer.borderColor   = UIColor.black.cgColor
        
        //fast button
        fastButton.layer.cornerRadius    = 5
        fastButton.layer.borderWidth     = 1
        fastButton.layer.borderColor     = UIColor.black.cgColor
        
        //back button
        backButton.layer.cornerRadius    = 5
        backButton.layer.borderWidth     = 1
        backButton.layer.borderColor     = UIColor.black.cgColor
        
        //forward button
        forwardButton.layer.cornerRadius = 5
        forwardButton.layer.borderWidth  = 1
        forwardButton.layer.borderColor  = UIColor.black.cgColor
    }
    
    //skip track ahead 15 seconds at a time
    @IBAction func skipForward(_ sender: Any) {
        audioPlayer.currentTime += 15
    }
    
    //skip song back 15 seconds
    @IBAction func skipBack(_ sender: Any) {
        audioPlayer.currentTime -= 15
    }
    
    //stop song and reset to beginning of song and set speed back to normal
    @IBAction func stopMusic(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate        = 1.0
        isPlaying               = false
    }
    
    //update slider location based on current song time
    func updateScrub(_ sender: Any){
        timeSlider.value = Float(audioPlayer.currentTime)
    }
    
    //update song based on pisition of slider
    @IBAction func scrub(_ sender: Any) {
        audioPlayer.currentTime = TimeInterval(timeSlider.value)
    }
    
    //display time left in song
    func timeRemaining(){
        let currentTime = Int(audioPlayer.duration) - Int(audioPlayer.currentTime)
        let minutes     = currentTime/60
        let seconds     = currentTime - minutes * 60
        timeLeft.text   = NSString(format: "-%02d:%02d", minutes, seconds) as String
    }
    
    //time passed in song
    func updateTime(){
        let currentTime = Int(audioPlayer.currentTime)
        let minutes     = currentTime/60
        let seconds     = currentTime - minutes * 60
        playedTime.text = NSString(format: "%02d:%02d", minutes, seconds) as String
    }
    
    //speak song title on load of song
    func speak(){
        let utterance   = AVSpeechUtterance(string: trackTitle.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate  = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    //set song back to default speed
    @IBAction func normalSpeed(_ sender: Any) {
        audioPlayer.rate = 1.0
    }
    
    //adjust speed of song to half
    @IBAction func slowSong(_ sender: Any) {
        audioPlayer.rate = 0.5
    }
    
    //speed up song to 2x speed
    @IBAction func fastSong(_ sender: Any) {
        audioPlayer.rate = 2.0
    }
    
    //PICKER FUNCTIONS
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //update song chosen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stopMusic(pickerView)
        if (row == 0) {
            songChosen = "Take A Chance On Me"
            beginSong()
        } else if (row == 1) {
            songChosen = "Re_ Your Brains"
            beginSong()
        } else if (row == 2) {
            songChosen = "I Wanna Be Sedated"
            beginSong()
        }else if (row == 3){
            songChosen = "New Math"
            beginSong()
        }
    }

}

