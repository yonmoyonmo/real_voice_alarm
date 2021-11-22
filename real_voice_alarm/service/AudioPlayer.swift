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
    
    var audioPlayer: AVAudioPlayer?
    
    @Published var isPlaying = false
    
    
    func startAlarmSound(audio: URL, volume: Float){
        //print("============= startAlarmSound debug ================")
        let playbackSession = AVAudioSession.sharedInstance()
        do{
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }catch let Error{
            print("Playing over the device's speakers failed :\(Error.localizedDescription)")
        }
        
        do{
            //print("let's play alarm sound at \(audio)")
            audioPlayer = try AVAudioPlayer.init(contentsOf: audio)
            
            audioPlayer?.delegate = self
            audioPlayer?.volume = volume
            audioPlayer?.numberOfLoops = 30
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
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer?.delegate = self
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


