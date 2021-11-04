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
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
        didSet{
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    
    func startAlarmSound(audio: URL, volume: Float){
        let playbackSession = AVAudioSession.sharedInstance()
        do{
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }catch{
            print("Playing over the device's speakers failed")
        }
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.volume = volume
            audioPlayer.numberOfLoops = 30
            audioPlayer.play()
            isPlaying = true
            print("playing Alarm")
        }catch{
            print("alarm sound failed")
        }
    }
    
    func startPlayback(audio: URL){
        let playbackSession = AVAudioSession.sharedInstance()
        
        do{
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }catch{
            print("Playing over the device's speakers failed")
        }
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
            print("playing playback")
        }catch{
            print("Playback failed")
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
        print("stopped")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            isPlaying = false
        }
    }
}
