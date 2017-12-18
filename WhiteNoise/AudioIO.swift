//
//  AudioIO.swift
//  WhiteNoise
//
//  Created by yamaken on 2017/12/16.
//  Copyright © 2017年 yamaken. All rights reserved.
//

import AVFoundation
import GameplayKit

class AudioIO {
    var audioEngine: AVAudioEngine
    var audioInputNode : AVAudioInputNode
    var audioPlayerNode: AVAudioPlayerNode
    var audioMixerNode: AVAudioMixerNode
    var audioBuffer: AVAudioPCMBuffer
    
    let b:[Float] = [1.0,  -1.4, 1.0]
    let a:[Float] = [1.0, -1.3, 0.5]
    var v1m1 : Float = 0.0, v2m1 :Float = 0.0, v1m:Float = 0.0, v2m :Float = 0.0;

    //var whiteNoise = [Float]()
    
    
    
    func iirfilter(x1:Float) -> Float {
        let y1 = (b[0] * x1 + v1m1) / a[0];
        v1m = (b[1] * x1 + v2m1) - a[1] * y1;
        v2m = b[2] * x1 - a[2] * y1;
        v1m1 = v1m;
        v2m1 = v2m;
        return y1;
    }
    
    init(){
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioMixerNode = audioEngine.mainMixerNode
        
        //whiteNoise = [Float](repeating: 0, count: Int(numSamples))
        let frameLength = UInt32(2048)
        audioBuffer = AVAudioPCMBuffer(pcmFormat: audioPlayerNode.outputFormat(forBus: 0), frameCapacity: frameLength)!
        audioBuffer.frameLength = frameLength
        
        audioInputNode = audioEngine.inputNode
        
        let anotherGaussian = GKGaussianDistribution(lowestValue: -10000, highestValue: 10000)
        
        audioInputNode.installTap(onBus: 0, bufferSize:frameLength, format: audioInputNode.outputFormat(forBus: 0), block: {(buffer, time) in
//            let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(buffer.format.channelCount))
//            let floats = UnsafeBufferPointer(start: channels[0], count: Int(buffer.frameLength))
//            var val : Float = 0.0
//            var outVal : Float = 0.0
//            print("channels:\(self.audioMixerNode.outputFormat(forBus: 0).channelCount)")
            for i:Int in stride(from: 0, to: 2*Int(self.audioBuffer.frameLength), by:     Int(self.audioMixerNode.outputFormat(forBus: 0).channelCount))
            {
                // doing my real time stuff
                //self.audioBuffer.floatChannelData?.pointee[i] = floats[i];
                let val = Float(anotherGaussian.nextInt()) / 30000.0
                //self.whiteNoise[i] = val
                //val = floats[i]
                print(val)
                
                //outVal = self.iirfilter(x1: floats[i])
                
                self.audioBuffer.floatChannelData?.pointee[i] = val
//                self.audioBuffer.floatChannelData?.pointee[i+Int(self.audioBuffer.frameLength)] = val
                self.audioBuffer.floatChannelData?.pointee[i+1] = val
            }
        })
        
        audioEngine.attach(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: audioMixerNode, format: audioPlayerNode.outputFormat(forBus: 0))
        
        
        //        // setup audio engine
        //        audioEngine.attach(audioPlayerNode)
        //        audioEngine.connect(audioPlayerNode, to: audioMixerNode, format: audioPlayerNode.outputFormat(forBus: 0))
        //        //audioEngine.startAndReturnError(nil)
        //
        //        do {
        //                try audioEngine.start()
        //        } catch let err as NSError {
        //                print(err)
        //        }
        //
        //
        //        // play player and buffer
        //        audioPlayerNode.play()
        //        audioPlayerNode.scheduleBuffer(audioBuffer, at: nil, options: .loops, completionHandler: nil)
    }
}

