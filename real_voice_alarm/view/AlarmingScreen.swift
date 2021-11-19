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
    @State var showModal:Bool = false
    @State var isDay:Bool = false
    
    var body: some View {
        //conditional Screen
        if recorderAlarm.isFiring == false {
            VoiceAlarmHome()
        }
        Text("alarming").padding()
        Button(action: {
            //recorderAlarm.isFiring = false 일단 기다려
            audioPlayer.stopPlayback()
            recorderAlarm.removeDeliverdAlarms()
            showModal.toggle()
        }){
            Text("dismiss")
        }.onAppear(perform: {
            alarmingScreenVm.getCurrentAlarm(id: recorderAlarm.firingAlarmId)
            let floatVolume = Float(alarmingScreenVm.currentAlarm.volume)
            self.isDay = alarmingScreenVm.currentAlarm.isDay
            audioPlayer.startAlarmSound(audio: alarmingScreenVm.currentAlarm.audioURL!, volume: floatVolume)
        }).sheet(isPresented: self.$showModal) {
            AfterAlarmScreen(isDay: isDay)
        }
    }
}

struct AlarmingScreen_Previews: PreviewProvider {
    static var previews: some View {
        AlarmingScreen()
    }
}
