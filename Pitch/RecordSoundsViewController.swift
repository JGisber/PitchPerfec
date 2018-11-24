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
	
	func setUI(state: Bool) {
		recordingLabel.text = state ? "Recording in Progress" : "Tap to Record"
		stopRecordingButton.isEnabled = state
		recordButton.isEnabled = !state
	}

	@IBAction func recordButton(_ sender: UIButton) {
		setUI(state: true)

		
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
		setUI(state: false)
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
		guard segue.identifier == "stopRecording" else {return}
		guard let playSoundsVC = segue.destination as? PlaySoundsViewController else {return}
		guard let recordedAudioURL = sender as? URL else {return}
		playSoundsVC.recordedAudioURL = recordedAudioURL
		}
}


