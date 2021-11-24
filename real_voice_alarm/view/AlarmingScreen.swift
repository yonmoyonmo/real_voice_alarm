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
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 15){
                Text("나와의 약속을 지킬 때예요!!").font(.system(size: 25, weight: .bold)).foregroundColor(Color.white).padding()
                Text(alarmingScreenVm.currentAlarm.fireAt!, style: .time)
                    .font(.system(size: 40, weight: .bold)).tracking(2).foregroundColor(.white)
                Spacer()
                HStack(alignment:.center, spacing: 30){
                    Button(action: {
                        if(snoozeMinutes > 5){
                            snoozeMinutes -= 5
                        }
                    }, label: {
                        Image(systemName: "minus.circle").font(.system(size: 50, weight: .bold)).foregroundColor(Color.white).padding()
                    })
                    Button(action: {
                        if(snoozeMinutes < 60){
                            snoozeMinutes += 5
                        }
                    }, label: {
                        Image(systemName: "plus.circle").font(.system(size: 50, weight: .bold)).foregroundColor(Color.white).padding()
                    })
                }
                Button{
                    audioPlayer.stopPlayback()
                    recorderAlarm.removeDeliverdAlarms()
                    showSnoozeConfirmAlert.toggle()
                } label:{
                    
                    Text("\(snoozeMinutes)분 미루기")
                        .font(.system(size: 28))
                        .frame(maxWidth: 400)
                        .padding()
                        .foregroundColor(.black)
                    
                }.alert(isPresented: $showSnoozeConfirmAlert){
                    Alert(title: Text("Alarm Snoozed!"), message: Text("\(snoozeMinutes)분 뒤에 봅시다"), dismissButton: .default(Text("오케이"), action: {
                        recorderAlarm.snoozeAlarm(alarm: alarmingScreenVm.currentAlarm, snoozeMimutes: snoozeMinutes)
                        recorderAlarm.isFiring = false
                    }))
                }.background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .opacity(0.8)
                    .shadow(radius: 5, x: 0, y: 5)
                    .padding()
                Button{
                    audioPlayer.stopPlayback()
                    recorderAlarm.removeDeliverdAlarms()
                    showModal.toggle()
                } label: {
                    Text("해제")
                        .font(.system(size: 28, weight: .bold))
                        .frame(maxWidth: 400)
                        .padding()
                        .foregroundColor(.black)
                }.background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .opacity(0.8)
                    .shadow(radius: 5, x: 0, y: 5)
                    .padding()
                Spacer()
                
            }.onAppear(perform: {
                alarmingScreenVm.getCurrentAlarm(id: recorderAlarm.firingAlarmId)
                
                let floatVolume = Float(alarmingScreenVm.currentAlarm.volume)
                
                self.isDay = alarmingScreenVm.currentAlarm.isDay
                
                //------------- canceling pending ringing notis ----------------
                recorderAlarm.cancelRingingPendingAlarms()
                //--------------------------------------------------------------
                
                audioPlayer.startAlarmSound(audio: alarmingScreenVm.currentAlarm.audioURL!, volume: floatVolume)
            }).sheet(isPresented: self.$showModal) {
                AfterAlarmScreen(isDay: isDay)
            }
        }
        
    }
}

struct AlarmingScreen_Previews: PreviewProvider {
    static var previews: some View {
        AlarmingScreen()
    }
}
