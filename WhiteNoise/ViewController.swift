//
//  ViewController.swift
//  WhiteNoise
//
//  Created by yamaken on 2017/12/13.
//  Copyright © 2017年 yamaken. All rights reserved.
//

import UIKit
import AVFoundation
import GameplayKit


class ViewController: UIViewController {
    var audioIO: AudioIO!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var frequencyBar: UISlider!
    @IBOutlet weak var frequencyValueLabel: UILabel!

    var frequencyValue:Float = 0.0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        audioIO = AudioIO()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func TouchPlayButton(_ sender: UIButton) {
        if playButton.currentTitle == "再生" {
            playButton.setTitle("停止", for: UIControlState.normal)
            
            do {
                try audioIO.audioEngine.start()
            } catch let err as NSError {
                print(err)
            }
            
            
            // play player and buffer
            audioIO.audioPlayerNode.play()
            audioIO.audioPlayerNode.scheduleBuffer(audioIO.audioBuffer, at: nil, options: .loops, completionHandler: nil)
            
        }else{
            playButton.setTitle("再生", for: UIControlState.normal)
//
            audioIO.audioEngine.stop()
            audioIO.audioPlayerNode.stop()
            //print(audioIO.whiteNoise)
        }
    }
    
    @IBAction func TouchFrequencyBar(_ sender: UISlider) {
        frequencyValue = frequencyBar.value
        frequencyValueLabel.text = String(frequencyValue) + "Hz"
    }
    
}

