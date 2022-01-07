//
//  AudioPlayer.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject,ObservableObject, AVAudioPlayerDelegate {
    static let instance = AudioPlayer()
    
    override init() {
        super.init()
        print("audio player initialized")
    }
    
    var audioPlayer: AVAudioPlayer?
    
    @Published var isPlaying = false
    
    func startAlarmSound(audio: URL, volume: Float){
        let playbackSession = AVAudioSession.sharedInstance()
        
        //3트까지 해봄으로써 OSStatus -50을 막아본다... -> 5트까지 도전...
        do{
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }catch let error{
            do{
                try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            }catch let error2{
                do{
                    try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                }catch let error3{
                    do{
                        try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                    }catch let error4{
                        do{
                            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                        }catch let error5{
                            print("Playing over the device's speakers failed :\(error5.localizedDescription) 5try")
                        }
                        print("Playing over the device's speakers failed :\(error4.localizedDescription) 4try")
                    }
                    print("Playing over the device's speakers failed :\(error3.localizedDescription) 3try")
                }
                print("Playing over the device's speakers failed :\(error2.localizedDescription) 2try")
            }
            print("Playing over the device's speakers failed :\(error.localizedDescription) 1try")
        }
        
        do{
            try playbackSession.setCategory(AVAudioSession.Category.playback)
            try playbackSession.setActive(true)
        }catch let error{
            print("startAlarmSound AVAudioSessionset Category error : \(error)")
        }
        
        do{
            print("let's play alarm sound at \(audio)")
            audioPlayer = try AVAudioPlayer.init(contentsOf: audio)
            audioPlayer?.delegate = self
            audioPlayer?.volume = volume
            audioPlayer?.numberOfLoops = 30
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
            
        }catch let Error{
            print("Playing audio failed :\(Error.localizedDescription) || \(Error)")
        }
    }
    
    func startPlayback(audio: URL){
        let playbackSession = AVAudioSession.sharedInstance()
        
        do{
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }catch let error{
            print("Playing over the device's speakers failed : \(error)")
        }
        
        do{
            try playbackSession.setCategory(AVAudioSession.Category.playback)
            try playbackSession.setActive(true)
        }catch let error{
            print("startPlayback AVAudioSessionset Category error : \(error)")
        }
        
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
            //print("playing playback")
        }catch let Error{
            print(" playback failed :\(Error.localizedDescription)")
        }
    }
    
    func stopPlayback() {
        if(isPlaying){
            audioPlayer?.stop()
            isPlaying = false
            print("stopped")
        }else{
            print("it's not playing")
            return
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            isPlaying = false
        }
    }
}



