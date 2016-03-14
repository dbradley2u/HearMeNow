//
//  ViewController.swift
//  HearMeNow
//
//  Created by Denise Bradley on 3/13/16.
//  Copyright © 2016 Denise Bradley. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var hasRecording = false
    var soundPlayer : AVAudioPlayer?
    var soundRecorder : AVAudioRecorder?
    var session : AVAudioSession?
    var soundPath : String?
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
        
    @IBAction func recordPressed(sender: AnyObject) {
        if(soundRecorder?.recording == true)
        {
            soundRecorder?.stop()
            recordButton.setTitle("Record", forState: UIControlState.Normal)
            hasRecording = true
        }
        else
        {
            session?.requestRecordPermission(){
                granted in
                if(granted == true)
                {
                    self.soundRecorder?.record()
                    self.recordButton.setTitle("Stop", forState: UIControlState.Normal)
                }
                else
                {
                    print("Unable to record")
                }
            }
        }
    }
    
    @IBAction func playPressed(sender: AnyObject) {
        if(soundPlayer?.playing == true)
        {
            soundPlayer?.pause()
            playButton.setTitle("Play", forState: UIControlState.Normal)
        }
        else if(hasRecording == true)
        {
            let url = NSURL(fileURLWithPath: soundPath!)
            var error : NSError?
            
            //This now requires a throw
            //soundPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
            
            do {
                try soundPlayer = AVAudioPlayer(contentsOfURL: url)
            }
            catch let error {
                print("Error initializing the recorder: \(error)")
            }
            
            if(error == nil)
            {
                soundPlayer?.delegate = self
                soundPlayer?.play()
            }
            else
            {
                print("Error initializing player \(error)")
            }
            playButton.setTitle("Pause", forState: UIControlState.Normal)
            hasRecording = false
        }
        else if(soundPlayer != nil)
        {
            soundPlayer?.play()
            playButton.setTitle("Pause", forState: UIControlState.Normal)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        recordButton.setTitle("Record", forState: UIControlState.Normal)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("Play", forState: UIControlState.Normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPath = "\(NSTemporaryDirectory())hearmenow.wav"
        
        let url = NSURL(fileURLWithPath: soundPath!)
        
        session = AVAudioSession.sharedInstance()
        
        //This now requires a throw
        //session?.setActive(true, error: nil)
        
        var error : NSError?
        
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0]
        
        //These now require a throw
        //session?.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        //soundRecorder = AVAudioRecorder(URL: url, settings: nil, error: &error)
        
        do{
           try session?.setActive(true)
        }
        catch let error {
            print("Error initializing the recorder: \(error)")
        }
        
        do{
            try session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }
        catch let error {
            print("Error initializing the recorder: \(error)")
        }
        
        do {
            try soundRecorder = AVAudioRecorder(URL: url, settings: recordSettings as! [String : AnyObject])
        }
        catch let error {
            print("Error initializing the recorder: \(error)")
        }
        
        //This now part of the try/catch
        //if(error == nil)
        //{
        //    print("Error initializing the recorder: \(error)")
        //}
        
        soundRecorder?.delegate = self
        soundRecorder?.prepareToRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

