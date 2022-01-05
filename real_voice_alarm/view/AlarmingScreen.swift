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
    @ObservedObject var alarmingScreenVm: AlarmingScreenViewModel = AlarmingScreenViewModel()
    
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
            Group{
                VStack{
                    Group{
                        Group{
                            Text("나와의 약속을 지킬 때예요!!").font(.system(size: 25, weight: .bold)).foregroundColor(Color.white)
                            Text(alarmingScreenVm.currentAlarm!.fireAt!, style: .time).font(.system(size: 40, weight: .bold)).tracking(2).foregroundColor(.white)
                        }.frame(width: CGFloat(geometry.size.width * 0.85), height: CGFloat(UIScreen.screenHeight / 9), alignment: .center).padding()
                        
                        HStack(alignment:.center, spacing: 10){
                            Image(systemName: "arrow.left").font(.system(size: 30, weight: .bold)).foregroundColor(Color.white)
                            
                            Button(action: {
                                if(snoozeMinutes > 5){
                                    snoozeMinutes -= 5
                                }
                            }, label: {
                                Image(systemName: "minus.circle").font(.system(size: 50, weight: .bold)).foregroundColor(Color.white)
                                    .padding(.trailing, 10)
                            })
                            Button(action: {
                                if(snoozeMinutes < 60){
                                    snoozeMinutes += 5
                                }
                            }, label: {
                                Image(systemName: "plus.circle").font(.system(size: 50, weight: .bold)).foregroundColor(Color.white)
                                    .padding(.leading, 10)
                            })
                            
                            Image(systemName: "arrow.right").font(.system(size: 30, weight: .bold)).foregroundColor(Color.white)
                        }.frame(width: CGFloat(geometry.size.width / 9), height: CGFloat(UIScreen.screenHeight * 0.2), alignment: .center).padding()
                    }
                    Group{
                        Button{
                            audioPlayer.stopPlayback()
                            recorderAlarm.removeDeliverdAlarms()
                            showSnoozeConfirmAlert.toggle()
                        } label:{
                            
                            Text("\(snoozeMinutes)분 미루기")
                                .font(.system(size: 28))
                                .frame(maxWidth: 270)
                                .foregroundColor(.black)
                                .padding()
                            
                        }.alert(isPresented: $showSnoozeConfirmAlert){
                            Alert(title: Text("\(snoozeMinutes)분 뒤에 다시 알람이 울립니다."), dismissButton: .default(Text("OK").font(.system(size: 20)), action: {
                                recorderAlarm.snoozeAlarm(alarm: alarmingScreenVm.currentAlarm!, snoozeMimutes: snoozeMinutes)
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
                            if(alarmingScreenVm.currentAlarm!.isRepeating == false){
                                recorderAlarm.switchScheduledAlarms(isOn: false, alarm: alarmingScreenVm.currentAlarm!)
                            }
                            showModal.toggle()
                        } label: {
                            Text("해제")
                                .font(.system(size: 28, weight: .bold))
                                .frame(maxWidth: 270)
                                .foregroundColor(.black)
                                .padding()
                            
                        }.background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .opacity(0.8)
                            .shadow(radius: 5, x: 0, y: 5)
                            .padding()
                    }
                    
                }//vstck
                .onAppear(perform: {
                    while(alarmingScreenVm.currentAlarm == nil){
                        alarmingScreenVm.getCurrentAlarm()
                    }
                    let floatVolume = Float(alarmingScreenVm.currentAlarm!.volume)
                    
                    self.isDay = alarmingScreenVm.currentAlarm!.isDay
                    
                    //------------- canceling pending ringing notis ----------------
                    recorderAlarm.cancelRingingPendingAlarms()
                    //--------------------------------------------------------------
                    if(alarmingScreenVm.currentAlarm != nil){
                        print("now playing this \(alarmingScreenVm.currentAlarm!.audioURL!) if player chrash? its not the URL's fault")
                        audioPlayer.startAlarmSound(audio: alarmingScreenVm.currentAlarm!.audioURL!, volume: floatVolume)
                    }
                }).sheet(isPresented: self.$showModal) {
                    AfterAlarmScreen(isDay: isDay)
                }
                
            }.frame(width: CGFloat(geometry.size.width),height: UIScreen.screenHeight, alignment: .center)
        }
        
    }
}
