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
    @State var fileName: String = "제목 없음"
    //----------------------------------------
    @State var isShowingTagNameEditAlert: Bool = false
    @State var isPlayBack: Bool = false
    //----------------------------------------
    
    func updateAlarm(){
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
            recorderAlarm.setLastingTimeOfNext()
            
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
            recorderAlarm.setLastingTimeOfNext()
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .center){
                    HStack{
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("취소").foregroundColor(.black).padding()
                        }
                        Spacer()
                        Button(action: {
                            updateAlarm()
                        }){
                            Text("완료").bold().padding()
                        }
                    }
                    
                    //date picker
                    GroupBox{
                        DatePicker("", selection: $fireAtEditted,
                                   displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                    }.frame(width: (UIScreen.screenWidth)-40)
                    
                    //repeating days
                    GroupBox{
                        RepeatDaysSettingView(repeatDays: $repeatDaysEditted).padding(5)
                    }.frame(width: (UIScreen.screenWidth)-40)
                    
                    
                    GroupBox{
                        HStack{
                            Label("태그", systemImage: "tag.fill")
                            Spacer()
                            Text("\(tagNameEditted)").onTapGesture {
                                isShowingTagNameEditAlert.toggle()
                            }
                        }
                    }.frame(width: (UIScreen.screenWidth)-40)
                    
                    
                    GroupBox{
                        HStack{
                            Image(systemName: "speaker.wave.3.fill")
                            //volume slider
                            Slider(value: $volumeEditted, in: 0...20, step: 0.1)
                        }
                        Divider()
                        HStack{
                            Text("현재 목소리 : \(audioNameEditted)").foregroundColor(.black)
                            Spacer()
                            NavigationLink(destination: RecordingsList(
                                audioRecorder: audioRecorder,
                                audioName:$audioNameEditted,
                                audioURL:$audioURLEditted)
                            ){
                                Text("목소리 고르기").bold()
                            }
                        }
                        
                    }.frame(width: (UIScreen.screenWidth)-40).padding(.horizontal)
                    
              
                    //@@@@@@@@@<< recorder  >>@@@@@@@@@@@@@@//
                    if(audioRecorder.recording == true){
                        Image("recording").frame(width: (UIScreen.screenWidth)-40)
                    }else{
                        Image("notRecording").frame(width: (UIScreen.screenWidth)-40)
                    }
                    if audioRecorder.recording == false {
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
                        }.padding()
                        
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
                        }.padding()
                    }
                    Spacer()
                }
            }
            .tagNameAlert(isShowing: $isShowingTagNameEditAlert, text: $tagNameEditted, title:"알람의 태그를 입력하세요")
            .playBackAlert(isShowing: $isPlayBack, audioPlayer: self.audioPlayer, audioURL: $audioURLEditted, audioName: $audioNameEditted)
            .navigationBarHidden(true)
        }
        
    }
}
