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

    
    
    required init(coder aDecoder: NSCoder) {
        
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        self.audioURL = NSUUID().UUIDString + ".m4a"
        var pathComponents = [baseString, self.audioURL]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        var recordSettings: [NSObject : AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2
        
        self.audioRecorder = AVAudioRecorder(URL: audioNSURL, settings: recordSettings, error: nil)
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        
        // Super init is called below to complete the remaining part of the object
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var buttonRecord: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    
    var audioRecorder : AVAudioRecorder
    var audioURL : String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Disable the button save and play as no new sound has been recorded yet
        self.buttonSave.enabled = false;
        self.buttonPlay.enabled = false;
        
    }

    @IBAction func buttonCancelTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func buttonRecordAudioTapped(sender: AnyObject) {
        
        if self.audioRecorder.recording
        {
            self.audioRecorder.stop();
            self.buttonRecord.setTitle("Record an audio babble", forState: UIControlState.Normal);
            self.buttonPlay.enabled = true;
            self.buttonSave.enabled = true;

        }else{
            var session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            self.audioRecorder.record()//start recording
            self.buttonRecord.setTitle("Stop Recording", forState: UIControlState.Normal);
            self.buttonPlay.enabled = false;
            self.buttonSave.enabled = false;
            
        }//else ends here.
        
    }//function buttonRecordAudioTapped ends here.
    
    @IBAction func buttonPlayTapped(sender: AnyObject) {
        
    }
    
    @IBAction func buttonSaveTapped(sender: AnyObject) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
