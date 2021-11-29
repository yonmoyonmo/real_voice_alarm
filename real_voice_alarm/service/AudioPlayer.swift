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
    
//    //----------무음모드 딱 거기 서!-----------//
//    @Published var isSilence = false
//    var startTime:DispatchTime?
//    var endTime:DispatchTime?
//    //------------------------------------//
    
    func startAlarmSound(audio: URL, volume: Float){
        //print("============= startAlarmSound debug ================")
        let playbackSession = AVAudioSession.sharedInstance()
        
        do{
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }catch let Error{
            print("Playing over the device's speakers failed :\(Error.localizedDescription)")
        }
        
        do{
            try playbackSession.setCategory(AVAudioSession.Category.playback)
            try playbackSession.setActive(true)
        }catch let error{
            print("startAlarmSound AVAudioSessionset Category error : \(error)")
        }
        
        do{
            //print("let's play alarm sound at \(audio)")
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
    
    //무음모드인지 아닌지를 알아내야 하는디.....
    // 1. 아무 소리 안나는 소리가 0.1초 미만으로 재생되고 멈추면 무음모드임
    // 2. 재생의 시작시간과 끝 시간을 구해서 무음인지 아닌지를 boolean값으로 유지할 것임
    // -> 안되노??? 무음모드라도 재생을 끝까지 해버리노?
//    func checkIfSilence(){
//        guard let audioData = NSDataAsset(name: "silenceCheck")?.data else {
//            fatalError("Unable to find asset silenceCheck")
//        }
//
//        let playbackSession = AVAudioSession.sharedInstance()
//
//        do{
//            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//        }catch let error{
//            print("Playing over the device's speakers failed : \(error)")
//        }
//
//        do{
//            try playbackSession.setCategory(AVAudioSession.Category.soloAmbient)
//            try playbackSession.setActive(true)
//        }catch let error{
//            print("checkIfSilence AVAudioSessionset Category error : \(error)")
//        }
//
//        do{
//            audioPlayer = try AVAudioPlayer(data: audioData)
//            audioPlayer?.delegate = self
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.play()
//            print("play : \(DispatchTime.now()), \(type(of: DispatchTime.now()))")
//            self.startTime = DispatchTime.now()
//            isPlaying = true
//        }catch let Error{
//            print(" playback failed :\(Error.localizedDescription)")
//        }
//    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            isPlaying = false
        }
//        print("%%%%%%%%< audioPlayerDidFinishPlaying called >%%%%%%%%%%%%%")
//        print("stop : \(DispatchTime.now())")
//
//        if(startTime != nil){
//            self.endTime = DispatchTime.now()
//            let nanoTime:UInt64 = endTime!.uptimeNanoseconds - startTime!.uptimeNanoseconds
//            let timeInterval = Double(nanoTime) / 1_000_000_000
//            print("the interval : \(timeInterval)")
//            if(timeInterval < 1.0){
//                self.isSilence = true
//            }
//        }
       
    }
}



