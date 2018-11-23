//
//  RecordSoundsViewController.swift
//  Pitch
//
//  Created by Josue Gisber on 11/23/18.
//  Copyright © 2018 Mpixel Design & Development. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

	var audioRecorder: AVAudioRecorder!
	@IBOutlet weak var recordingLabel: UILabel!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var stopRecordingButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		stopRecordingButton.isEnabled = false
	}

	@IBAction func recordButton(_ sender: UIButton) {
		recordingLabel.text = "Recording in Progress"
		stopRecordingButton.isEnabled = true
		recordButton.isEnabled = false
		
		let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
		let recordingName = "recordedVoice.wav"
		let pathArray = [dirPath, recordingName]
		let filePath = URL(string: pathArray.joined(separator: "/"))
		
		let session = AVAudioSession.sharedInstance()
		try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
		
		try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
		audioRecorder.delegate = self
		audioRecorder.isMeteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
	}
	
	
	@IBAction func stopRecordingButton(_ sender: UIButton) {
		recordingLabel.text = "Tap to Record"
		recordButton.isEnabled = true
		stopRecordingButton.isEnabled = false
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		try! audioSession.setActive(false)
	}
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		switch flag {
		case true: performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
		case false: print("Recording was not Successful")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "stopRecording" {
			let playSoundsVC = segue.destination as! PlaySoundsViewController
			let recordeAudioURL = sender as! URL
			playSoundsVC.recordedAudioURL = recordeAudioURL
		}
	}
}

