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
    @State var audioURLException:Bool = false
    //----------------------------------------
    var themeType:String
    
    func updateAlarm(){
        if(audioURLEditted==nil){
            audioURLException.toggle()
            return
        }
        
        //sample checker
        if(!audioNameEditted.contains(".wav")){
            if(audioNameEditted.count < 4){
                audioNameEditted = "\(audioNameEditted).m4a"
            }else{
                let index = audioNameEditted.index(audioNameEditted.endIndex, offsetBy: -4)
                let extensionString = audioNameEditted[index...]
                if(extensionString != ".m4a"){
                    audioNameEditted = "\(audioNameEditted).m4a"
                }else{
                    print(audioNameEditted)
                }
            }
        }
        
        if(!repeatDaysEditted.isEmpty){
            //반복알람으로 수정
            var weekDayFireAtSet:[Date] = []
            let components = Calendar.current.dateComponents([.hour, .minute, .year], from: fireAtEditted)
            for repeatDay in repeatDaysEditted {
                weekDayFireAtSet.append(createDate(
                    weekday: repeatDay.intName,
                    hour:components.hour!,
                    minute:components.minute!,
                    year: components.year!,
                    month: nil,
                    day: nil
                ))
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
            print("!!!!!!!!!!!!!!!!!!!!!!!!!! alarmEdit fireAtEditted : \(fireAtEditted)")
            let now = Date()
            let nowDateComponents = Calendar.current.dateComponents([.year,.month,.day, .hour, .minute, .weekday, .second], from: now)
            var components = Calendar.current.dateComponents([.hour, .minute, .year, .month, .day], from: fireAtEditted)
            components.year = nowDateComponents.year!
            components.month = nowDateComponents.month!
            components.day = nowDateComponents.day!
            fireAtEditted = Calendar.current.date(from: components)!
            print("!!!!!!!!!!!!!!!!!!!!!!!!!! alarmEdit fireAtEditted after processing : \(fireAtEditted)")
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
        GeometryReader { geometry in
            NavigationView{
                ScrollView{
                    Group{
                        VStack(alignment: .center){
                            HStack{
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("취소").foregroundColor(Color.textBlack)
                                }
                                Spacer()
                                Button(action: {
                                    updateAlarm()
                                }){
                                    Text("완료").bold().foregroundColor(Color.myAccent)
                                }
                            }.padding(10)
                            
                            //date picker
                            GroupBox{
                                
                                DatePicker(selection: $fireAtEditted,
                                           displayedComponents: .hourAndMinute,
                                           label: {EmptyView()})
                                    .datePickerStyle(.wheel).labelsHidden()
                                    .frame(width: UIScreen.screenWidth > 700.0 ?
                                           400 :
                                            UIScreen.screenWidth * 0.87,
                                           alignment: .center)
                            }
                            
                            //repeating days
                            GroupBox(label: Label("요일반복", systemImage: "calendar")){
                                RepeatDaysSettingView(repeatDays: $repeatDaysEditted).padding(.top, 2)
                            }
                            
                            
                            GroupBox{
                                HStack{
                                    Label("태그", systemImage: "tag.fill")
                                    Spacer()
                                    Text("\(tagNameEditted)").font(.system(size:18, weight: .bold)).foregroundColor(Color.myAccent).onTapGesture {
                                        isShowingTagNameEditAlert.toggle()
                                    }
                                }
                            }
                            
                            
                            GroupBox{
                                HStack{
                                    Image(systemName: "speaker.wave.3.fill")
                                    //volume slider
                                    Slider(value: $volumeEditted, in: 0...2, step: 0.1)
                                }
                                Divider()
                                HStack{
                                    Text(audioNameEditted.contains(".wav") ?
                                         sampleNames[Int(audioNameEditted.split(separator: ".")[0])!]
                                         : audioNameEditted)
                                    //Text("\(audioNameEditted)")
                                    Spacer()
                                    NavigationLink(destination: RecordingsList(
                                        audioRecorder: audioRecorder,
                                        audioName:$audioNameEditted,
                                        audioURL:$audioURLEditted)
                                    ){
                                        Image(systemName: "waveform").font(.system(size:20, weight: .bold)).foregroundColor(Color.myAccent)
                                    }
                                }
                            }
                            
                            
                            //@@@@@@@@@<< recorder  >>@@@@@@@@@@@@@@//
                            if(audioRecorder.recording == true){
                                Image("recording")
                            }else{
                                Image("notRecording")
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
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, UIScreen.screenWidth > 700.0 ? 200 : 10)
                    .padding(.top, UIScreen.screenWidth > 700.0 ? 150 : 10)
                }.frame(width: CGFloat(geometry.size.width), alignment: .center)
                    .background(Image(themeType)
                                    .resizable()
                                    .aspectRatio(geometry.size.width, contentMode: .fill)
                                    .edgesIgnoringSafeArea(.all).edgesIgnoringSafeArea(.all))
                    .audioURLExceptionAlert(isShowing: $audioURLException, message: "알림 생성에는 목소리가 필요합니다.")
                    .tagNameAlert(isShowing: $isShowingTagNameEditAlert, text: $tagNameEditted)
                    .playBackAlert(isShowing: $isPlayBack, audioPlayer: self.audioPlayer, audioURL: $audioURLEditted, audioName: $audioNameEditted)
                    .navigationBarHidden(true)
            }.accentColor(.textBlack)
        }
    }
}
