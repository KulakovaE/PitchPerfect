//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Darko Kulakov on 2019-01-01.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(isRecording: false)
    }
  
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func configureUI(isRecording:Bool){
        
        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Recording"
        
        switch(isRecording){
        case true:
            stopRecordingButton.isEnabled = isRecording
            recordButton.isEnabled = !isRecording
        case false:
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "stopRecording"{
//            let playSoundsVC = segue.destination as! PlaySoundsViewController
//            let recordedAudioURL = sender as! URL
//            playSoundsVC.recordedAudioURL = recordedAudioURL
//        }
        
        guard segue.identifier == "stopRecording" else { return }
        guard let playSoundsVC = segue.destination as? PlaySoundsViewController else { return }
        guard let recoredAudio = sender as? URL else { return }
        playSoundsVC.recordedAudioURL = recoredAudio
    }
}
