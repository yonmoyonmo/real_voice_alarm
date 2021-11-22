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
    @State var snoozeMinutes:Int = 5
    @State var showSnoozeConfirmAlert:Bool = false
    
    var body: some View {
        //conditional Screen
        if recorderAlarm.isFiring == false {
            VoiceAlarmHome()
        }
        VStack{
            Text("alarming").padding()
            
            HStack{
                Button(action: {
                    print("snoozed")
                    audioPlayer.stopPlayback()
                    recorderAlarm.removeDeliverdAlarms()
                    showSnoozeConfirmAlert.toggle()
                }, label: {
                    Text("snooze")
                }).padding().alert(isPresented: $showSnoozeConfirmAlert){
                    Alert(title: Text("Alarm Snoozed!"), message: Text("\(snoozeMinutes)분 뒤에 봅시다"), dismissButton: .default(Text("오케이"), action: {
                        recorderAlarm.snoozeAlarm(alarm: alarmingScreenVm.currentAlarm, snoozeMimutes: snoozeMinutes)
                        recorderAlarm.isFiring = false
                    }))
                }
                
                Button(action: {
                    snoozeMinutes += 5
                }, label: {
                    Image(systemName: "plus")
                }).padding()
                
                Button(action: {
                    snoozeMinutes -= 5
                }, label: {
                    Image(systemName: "minus")
                }).padding()
            }
            
            Text("\(snoozeMinutes)분 뒤로 스누즈 ㄱ?").foregroundColor(.black)
            
            Button(action: {
                audioPlayer.stopPlayback()
                recorderAlarm.removeDeliverdAlarms()
                showModal.toggle()
            }){
                Text("dismiss")
            }
            
        }.onAppear(perform: {
            alarmingScreenVm.getCurrentAlarm(id: recorderAlarm.firingAlarmId)
            
            let floatVolume = Float(alarmingScreenVm.currentAlarm.volume)
            
            self.isDay = alarmingScreenVm.currentAlarm.isDay
            
//            if(alarmingScreenVm.currentAlarm.isRepeating == false){
//                recorderAlarm.alarmActiveSwitch(alarm: alarmingScreenVm.currentAlarm)
//            }
            
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
