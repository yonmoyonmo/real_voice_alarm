//
//  AlarmingScreen.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/29.
//

import SwiftUI

struct AlarmingScreen: View {
    @ObservedObject var recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    @StateObject var alarmingScreenVm: AlarmingScreenViewModel = AlarmingScreenViewModel()
    var audioPlayer: AudioPlayer = AudioPlayer()
    
    var body: some View {
        //conditional Screen
        if recorderAlarm.isFiring == false {
            VoiceAlarmHome()
        }
        
        Text("alarming").padding()
        Button(action: {
            recorderAlarm.isFiring = false
            audioPlayer.stopPlayback()
            recorderAlarm.removeDeliverdAlarms()
        }){
            Text("dismiss")
        }.onAppear(perform: {
            alarmingScreenVm.getCurrentAlarm(id: recorderAlarm.firingAlarmId)
            let floatVolume = Float(alarmingScreenVm.currentAlarm.volume)
            audioPlayer.startAlarmSound(audio: alarmingScreenVm.currentAlarm.audioURL!, volume: floatVolume)
        })
    }
}

struct AlarmingScreen_Previews: PreviewProvider {
    static var previews: some View {
        AlarmingScreen()
    }
}
