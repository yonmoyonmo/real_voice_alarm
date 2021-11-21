//
//  AlarmingScreen.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/29.
//

import SwiftUI
import AVFoundation

struct AlarmingScreen: View {
    @ObservedObject var recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    @StateObject var alarmingScreenVm: AlarmingScreenViewModel = AlarmingScreenViewModel()
    
    let audioPlayer = AudioPlayer.instance
    
    @State var showModal:Bool = false
    @State var isDay:Bool = false
    
    var body: some View {
        //conditional Screen
        if recorderAlarm.isFiring == false {
            VoiceAlarmHome()
        }
        Text("alarming").padding()
        Button(action: {
            audioPlayer.stopPlayback()
            recorderAlarm.removeDeliverdAlarms()
            showModal.toggle()
        }){
            Text("dismiss")
        }.onAppear(perform: {
            print("debug ringing \(recorderAlarm.firingAlarmId)")
            alarmingScreenVm.getCurrentAlarm(id: recorderAlarm.firingAlarmId)
            
            let floatVolume = Float(alarmingScreenVm.currentAlarm.volume)
            
            self.isDay = alarmingScreenVm.currentAlarm.isDay
            
            if(alarmingScreenVm.currentAlarm.isRepeating == false){
                recorderAlarm.alarmActiveSwitch(alarm: alarmingScreenVm.currentAlarm)
            }
            
            //------------- canceling pending ringing notis ----------------
            recorderAlarm.cancelRingingPendingAlarms()
            //--------------------------------------------------------------
            
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
