//
//  AlarmSetting.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import SwiftUI

struct AlarmSetting: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var vm:VoiceAlarmHomeViewModel
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder()
    let audioPlayer: AudioPlayer = AudioPlayer.instance
    let recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    //-----------------------------------------
    @State var tagName: String = "태그 없음"
    @State var fireAt: Date = Date()
    @State var repeatDays: [RepeatDays] = []
    
    @State var audioName: String = "선택된 목소리 없음"
    @State var audioURL: URL?
    @State private var volume: Double = 10
    
    @State var audioData: [String:Any] = [:]
    @State var fileName: String = "제목 없음"
    //----------------------------------------
    @State var isPlayBack: Bool = false
    @State var isShowingTagNameEditAlert:Bool = false
    @State var audioURLException:Bool = false
    //-----------------------------------------
    var isDay:Bool
    var themeType:String
    
    func saveAlarm(){
        if(audioURL==nil){
            audioURLException.toggle()
            return
        }
        //save alarm
        if(!audioName.contains(".wav")){
            if(audioName.count < 4){
                audioName = "\(audioName).m4a"
            }else{
                let index = audioName.index(audioName.endIndex, offsetBy: -4)
                let extensionString = audioName[index...]
                if(extensionString != ".m4a"){
                    audioName = "\(audioName).m4a"
                }else{
                    print(audioName)
                }
            }
        }
        
        if(!repeatDays.isEmpty){
            var weekDayFireAtSet:[Date] = []
            let components = Calendar.current.dateComponents([.hour, .minute, .year, .month, .day], from: fireAt)
            for repeatDay in repeatDays {
                weekDayFireAtSet.append(createDate(weekday: repeatDay.intName,
                                                   hour:components.hour!,
                                                   minute:components.minute! ,
                                                   year: components.year!,
                                                   month: components.month!,
                                                   day: components.day!
                                                  ))
            }
            recorderAlarm.saveRepeatingAlarms(tagName: tagName,
                                              fireAtList: weekDayFireAtSet,
                                              audioName: audioName,
                                              audioURL: audioURL!,
                                              volume: volume,
                                              repeatingDays : repeatDays)
            vm.getAlarms()
            recorderAlarm.setLastingTimeOfNext()
            
            self.presentationMode.wrappedValue.dismiss()
        }else{
            recorderAlarm.saveAlarm(tagName: tagName,
                                    fireAt: fireAt,
                                    audioName: audioName,
                                    audioURL: audioURL!,
                                    volume: volume,
                                    repeatingDays : repeatDays
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
                        VStack(alignment: .center) {
                            HStack(){
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("취소").foregroundColor(Color.textBlack)
                                })
                                Spacer()
                                //완료 버튼 : 알람 데이터 저장 + 스케쥴링
                                Button(action: {
                                    saveAlarm()
                                }, label:{
                                    Text("완료").foregroundColor(Color.myAccent)
                                })
                            }.padding(10)
                            //데이트 피커
                            GroupBox{
                                Group{
                                    if(isDay == true){
                                        HStack{
                                            Image(systemName: "sun.max").font(.system(size:20, weight: .bold)).foregroundColor(Color.textBlack)
                                            Text("아침과 낮의 모티보이스 : 04시 ~ 16시")
                                        }
                                        VStack{
                                            DatePicker(selection: $fireAt, displayedComponents: .hourAndMinute,
                                                       label:{ EmptyView()
                                            }).datePickerStyle(.wheel).labelsHidden()
                                                .frame(width: UIScreen.screenWidth > 700.0 ?
                                                       400 :
                                                        UIScreen.screenWidth * 0.87,
                                                       alignment: .center)
                                        }
                                    }else{
                                        HStack{
                                            Image(systemName: "moon.stars.fill").font(.system(size:20, weight: .bold)).foregroundColor(Color.textBlack)
                                            Text("저녁과 밤의 모티보이스 : 17시 ~ 03시")
                                        }
                                        VStack{
                                            DatePicker(selection: $fireAt, displayedComponents: .hourAndMinute,
                                                       label:{ EmptyView()
                                            }).datePickerStyle(.wheel).labelsHidden()
                                                .frame(width: UIScreen.screenWidth > 700.0 ?
                                                       400 :
                                                        UIScreen.screenWidth * 0.87,
                                                       alignment: .center)
                                        }
                                    }
                                }
                            }
                            
                            //요일 반복
                            GroupBox(label: Label("요일반복", systemImage: "calendar")){
                                RepeatDaysSettingView(repeatDays: $repeatDays).padding(.top, 2)
                            }
                            
                            GroupBox{
                                HStack{
                                    Label("태그", systemImage: "tag.fill")
                                    Spacer()
                                    Text("\(tagName)").font(.system(size:18, weight: .bold)).foregroundColor(Color.myAccent)
                                        .onTapGesture {
                                        isShowingTagNameEditAlert.toggle()
                                    }
                                }
                            }
                            
                            GroupBox{
                                HStack{
                                    Image(systemName: "speaker.wave.3.fill")
                                    //volume slider
                                    Slider(value: $volume, in: 0...20, step: 0.1)
                                }
                                Divider()
                                HStack{
                                    Text("\(audioName)")
                                    Spacer()
                                    NavigationLink(destination: RecordingsList(
                                        audioRecorder: audioRecorder,
                                        audioName:$audioName,
                                        audioURL:$audioURL)
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
                                }.padding()
                                
                            }else{
                                Button(action: {
                                    audioData = audioRecorder.stopRecording()
                                    audioName = audioData["audioName"] as! String
                                    audioURL = audioData["audioURL"] as? URL
                                    isPlayBack.toggle()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 70, height: 70)
                                        .clipped()
                                        .foregroundColor(.red)
                                }.padding()
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, UIScreen.screenWidth > 700.0 ? 200 : 10)
                    .padding(.top, UIScreen.screenWidth > 700.0 ? 150 : 10)
                }
                .frame(width: CGFloat(geometry.size.width), alignment: .center)
                .background(
                    isDay ? Image(themeType).resizable().aspectRatio(geometry.size.width, contentMode: .fill).edgesIgnoringSafeArea(.all)
                            :
                        Image("\(themeType)2").resizable().aspectRatio(geometry.size.width, contentMode: .fill).edgesIgnoringSafeArea(.all)
                )
                .audioURLExceptionAlert(isShowing: $audioURLException, message: "목소리 없이는 알람을 만들 수 없습니다.")
                .tagNameAlert(isShowing: $isShowingTagNameEditAlert, text: $tagName)
                .playBackAlert(isShowing: $isPlayBack,
                               audioPlayer: self.audioPlayer,
                               audioURL: $audioURL,
                               audioName:$audioName)
                .navigationBarHidden(true)
                .onAppear(){
                    //마이크 권한 요청
                    audioRecorder.requestMicrophonePermission()
                }
            }
        }.accentColor(.textBlack)//navi view end
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
