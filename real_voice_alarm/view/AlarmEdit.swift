//
//  AlarmEdit.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/08.
//

import SwiftUI

struct AlarmEdit: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var vm: VoiceAlarmHomeViewModel
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder()
    let audioPlayer: AudioPlayer = AudioPlayer()
    let recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    
    //args------------------------------------
    var alarm: AlarmEntity
    @State var tagNameEditted: String
    @State var fireAtEditted: Date
    @State var repeatDaysEditted: [RepeatDays]
    @State var audioNameEditted: String
    @State var audioURLEditted: URL?
    @State var volumeEditted: Double
    //----------------------------------------
    @State var audioData: [String:Any] = [:]
    @State var fileName: String = "default"
    //----------------------------------------
    @State var isShowingAlart: Bool = false
    @State var isPlayBack: Bool = false
    //----------------------------------------
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    HStack{
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("취소").foregroundColor(.black).padding()
                        }
                        Spacer()
                        Button(action: {
                            if(audioURLEditted==nil){
                                print("오디오 유알엘 없는 경우에 예외처리 하라")
                                vm.getAlarms()
                                self.presentationMode.wrappedValue.dismiss()
                                return
                            }
                            //save alarm
                            if(!repeatDaysEditted.isEmpty){
                                var weekDayFireAtSet:[Date] = []
                                let components = Calendar.current.dateComponents([.hour, .minute, .year], from: fireAtEditted)
                                
                                for repeatDay in repeatDaysEditted {
                                    weekDayFireAtSet.append(createDate(
                                        weekday: repeatDay.intName,
                                        hour:components.hour!,
                                        minute:components.minute!,
                                        year: components.year!)
                                    )
                                }
                                //반복알람 업데이트
                                recorderAlarm.updateRepeatingAlarms(
                                    alarm: alarm,
                                    tagName: tagNameEditted,
                                    fireAtList: weekDayFireAtSet,
                                    audioName: audioNameEditted,
                                    audioURL: audioURLEditted!,
                                    volume: volumeEditted,
                                    repeatingDays : repeatDaysEditted
                                )
                                vm.getAlarms()
                                self.presentationMode.wrappedValue.dismiss()
                            }else{
                                //반복알람 아닌 경우의 업데이트
                                recorderAlarm.updateAlarm(
                                    alarm: alarm,
                                    tagName: tagNameEditted,
                                    fireAt: fireAtEditted,
                                    audioName: audioNameEditted,
                                    audioURL: audioURLEditted!,
                                    volume: volumeEditted,
                                    repeatingDays : repeatDaysEditted
                                )
                                vm.getAlarms()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }){
                            Text("완료").bold().padding()
                        }
                    }
                    
                    DatePicker("", selection: $fireAtEditted, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel).padding()
                    
                    Group {
                        RepeatDaysSettingView(repeatDays: $repeatDaysEditted).padding()
                        
                        TextField("알람의 이름을...", text: $tagNameEditted).padding().textFieldStyle(.roundedBorder)
                        
                        NavigationLink(
                            destination: RecordingsList(
                                audioRecorder: audioRecorder,
                                audioName:$audioNameEditted,
                                audioURL:$audioURLEditted
                            )) {
                                Text("현재 목소리 : \(audioNameEditted)").foregroundColor(.black)
                                Spacer()
                                Text("목소리 고르기").bold()
                            }.padding()
                    }
                    
                    Slider(value: $volumeEditted, in: 0...20, step: 0.1).padding()
                    
                    if(audioRecorder.recording == true){
                        Image(systemName: "waveform.path").font(.system(size: 45, weight: .bold)).foregroundColor(.red)
                    }else{
                        Image(systemName: "waveform.path.ecg").font(.system(size: 45, weight: .bold)).foregroundColor(.black)
                    }
                    if audioRecorder.recording == false {
                        if fileName == "default" {
                            Button(action: {
                                isShowingAlart.toggle()
                            }) {
                                Image(systemName: "pencil.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipped()
                                    .foregroundColor(.red)
                                    .padding(.bottom, 40)
                            }
                        }else{
                            Button(action: {
                                audioRecorder.startRecording(title: "\(fileName)")
                            }) {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipped()
                                    .foregroundColor(.red)
                                    .padding(.bottom, 40)
                            }
                        }
                    }else{
                        Button(action: {
                            audioData = audioRecorder.stopRecording()
                            audioNameEditted = audioData["audioName"] as! String
                            audioURLEditted = audioData["audioURL"] as? URL
                            isPlayBack.toggle()
                        }) {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                        }
                    }
                    
                }.padding()
            }
            .textFieldAlert(isShowing: $isShowingAlart, text: $fileName, title: "녹음 파일 이름을 입력하세오")
            .playBackAlert(isShowing: $isPlayBack, audioPlayer: self.audioPlayer, audioURL: $audioURLEditted)
            .navigationBarHidden(true)
        }
        
    }
}
