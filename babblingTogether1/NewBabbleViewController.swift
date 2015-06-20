//
//  NewBabbleViewController.swift
//  babblingTogether1
//
//  Created by Macbook Pro Retina on 2015-06-20.
//  Copyright (c) 2015 Codopedia. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class NewBabbleViewController: UIViewController {

    //******************************************************************************************
    //init() function
    //******************************************************************************************
    
    required init(coder aDecoder: NSCoder) {
        
        var baseString: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        var pathComponents = [baseString, "sound.m4a"]
        self.audioURL = NSURL.fileURLWithPathComponents(pathComponents)!
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        var recordSettings: [NSObject : AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2
        
        self.audioRecorder = AVAudioRecorder(URL: self.audioURL, settings: recordSettings, error: nil)
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        
        super.init(coder: aDecoder)
    }
    
    //******************************************************************************************

    

    //**********************************************************************************
    // viewDidLoad() function begins here.
    //**********************************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Disable the button save and play as no new sound has been recorded yet
        self.buttonSave.enabled = false;
        self.buttonPlay.enabled = false;
        self.buttonDone.enabled = false;
        
    }
    
    //*********************************************************************************
    
    
    //**********************************************************************************
    //The user does not want to record or has recorded but will not save the babble.
    //**********************************************************************************

    @IBAction func buttonCancelTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    //***********************************************************************************
    
    
    //***********************************************************************************
    
   // Code dealing with starting recording a sound, pausing recording a sound
    //and stopping further recording the sound.
    
    //***********************************************************************************
    
    @IBOutlet weak var buttonRecord: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonDone: UIButton!
    
    var audioRecorder : AVAudioRecorder
    var audioPlayer = AVAudioPlayer();
    var audioURL = NSURL();
    var recordingPausedFlag = false;
    
    @IBAction func buttonRecordAudioTapped(sender: AnyObject) {
        if self.audioRecorder.recording
        {
            if recordingPausedFlag == false{
                pauseRecording();//Recording is going on and the user wants to pause it.
            }
            else{
                startRecording();//Recording was just pasused. Start it again.
            }

        }else{
            startRecording();
        }
    }//function buttonRecordAudioTapped ends here.
    
    
    func startRecording(){
        var session = AVAudioSession.sharedInstance()
        session.setActive(true, error: nil)
        self.audioRecorder.record()//start recording
        self.displayTimeLabel.enabled = true;
        startTimer(self);//start the timer
        self.buttonRecord.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        self.buttonRecord.setTitle("Press to Pause Recording", forState: UIControlState.Normal);
        self.recordingPausedFlag = false;
        self.buttonPlay.enabled = false;
        self.buttonSave.enabled = false;
        self.buttonDone.enabled = false;
    }
    
    func pauseRecording(){
        self.audioRecorder.pause();
        stopTimer(self);//Pause the timer
        self.buttonDone.enabled = true;
        self.buttonRecord.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal);
        self.buttonRecord.setTitle("Paused. Press to Resume", forState: UIControlState.Normal);
        self.buttonPlay.enabled = false;
        self.buttonSave.enabled = false;
        self.recordingPausedFlag = true;
    }
    
    @IBAction func buttonDoneRecordingTapped(sender: AnyObject) {
        
        if self.recordingPausedFlag == true {
            
            self.audioRecorder.stop();
            elapsedTime += startTimeDate.timeIntervalSinceNow
            timer.invalidate()
            self.buttonDone.enabled = false;
            self.recordingPausedFlag = false;
            self.buttonPlay.enabled = true;
            self.buttonSave.enabled = true;
            self.buttonRecord.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
            self.buttonRecord.setTitle("Recording Stopped", forState: UIControlState.Normal);
            self.buttonRecord.enabled = false;
            self.displayTimeLabel.enabled = false;
            //buttonSaveTapped(self);
        }
    }//function buttonDoneRecordingTapped
    
    //*****************************************************************************************
    
    
    //********************************************************************************************
    //Code dealing with playing/pausing and stopping the already recorded but not yet saved sound
    //********************************************************************************************
    
    var PlayingFlag = false;
    
    @IBAction func buttonPlayTapped(sender: AnyObject) {
        
        self.audioPlayer = AVAudioPlayer(contentsOfURL: self.audioURL, error: nil);
        if self.PlayingFlag  == false
        {
            self.audioPlayer.play();
            self.buttonPlay.setTitle("Tap to pause", forState: UIControlState.Normal);
            self.PlayingFlag = true;
        }
        else
        {
            self.audioPlayer.pause();
            self.buttonPlay.setTitle("Playing paused! Tap to continue playing", forState: UIControlState.Normal);
            self.PlayingFlag = false;
        }
    }//function buttonPlayTapped ends here.
    
//***************************************************************************************
    
    
    
    //*************************************************************************
    //Saving the recorded audio code starts here.
    //**************************************************************************
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    
    @IBAction func buttonSaveTapped(sender: AnyObject) {
        
        
        
        //Now that we have saved the sound, we have to go back to the list of babbles.
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    //***********************************************************************
    // Timer related code
    //***********************************************************************
    
    @IBOutlet weak var displayTimeLabel: UILabel!
    
    var startTime = NSTimeInterval();
    var elapsedTime = NSTimeInterval();
    var startTimeDate = NSDate();
    var elapsedTimeDate = NSDate();
    var timer = NSTimer();
    
    func startTimer(sender: AnyObject) {
        if !timer.valid {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTimeDate = NSDate()
            startTime = NSDate.timeIntervalSinceReferenceDate() + elapsedTime
        } else {
            elapsedTime += startTimeDate.timeIntervalSinceNow
            stopTimer(self);
        }
    }//function startTimer ends here.

    
    func updateTime(){
        var currentTime = NSDate.timeIntervalSinceReferenceDate();
        var elpasedTime : NSTimeInterval = currentTime - startTime;
        let (h,m,s) = calculateHoursMinutesSeconds(Int(elpasedTime));

        let strHours = String(format: "%02d", h);
        let strMinutes = String(format: "%02d", m);
        let strSeconds = String(format: "%02d", s);
        let timeLappsedTupple = (strHours, strMinutes, strSeconds);
        
        displayTimeLabel.text = "\(timeLappsedTupple.0):\(timeLappsedTupple.1):\(timeLappsedTupple.2)";
    }
    
    func calculateHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int){
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60);
    }
    
    func stopTimer(sender: AnyObject) {
        //elapsedTime = 0;
        elapsedTime += startTimeDate.timeIntervalSinceNow;
        if timer.valid {
            timer.invalidate();
        } else {
            displayTimeLabel.text = "00:00:00"
        }
        
    }//funciton stopTimer ends here.
    
//*************************************************************************************
    
}//class NewBabbleViewController ends here.
