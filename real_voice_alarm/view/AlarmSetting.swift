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
    @State var tagName: String = "default"
    @State var fireAt: Date = Date()
    @State var repeatDays: [RepeatDays] = []
    
    @State var audioName: String = "default"
    @State var audioURL: URL?
    @State private var volume: Double = 10
    
    @State var audioData: [String:Any] = [:]
    @State var fileName: String = "default"
    //----------------------------------------
    @State var isShowingAlart: Bool = false
    @State var isPlayBack: Bool = false
    //-----------------------------------------
    
    var isDay:Bool
    
    var DaydateClosedRange: ClosedRange<Date> {
        
        var minComps = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: Date())
        minComps.hour = 0
        minComps.minute = 0
        
        var maxComps = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: Date())
        maxComps.hour = 11
        maxComps.minute = 59
        
        let myCalendar = Calendar(identifier: .gregorian)
        
        let min = myCalendar.date(from: minComps)!
        let max = myCalendar.date(from: maxComps)!
        
        return min...max
    }
    
    var NightdateClosedRange: ClosedRange<Date> {
        
        var minComps = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: Date())
        minComps.hour = 12
        minComps.minute = 0
        
        var maxComps = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: Date())
        maxComps.hour = 23
        maxComps.minute = 59
        
        let myCalendar = Calendar(identifier: .gregorian)
        
        let min = myCalendar.date(from: minComps)!
        let max = myCalendar.date(from: maxComps)!
        
        return min...max
    }
    
    //예외처리 잔뜩 해야한다.
    //일단 이름짓는 것들 길이제한부터
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .center) {
                    HStack(){
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("취소").foregroundColor(.black).padding()
                        })
                        Spacer()
                        //완료 버튼 : 알람 데이터 저장 + 스케쥴링
                        Button(action: {
                            if(audioURL==nil){
                                print("오디오 유알엘 없는 경우에 예외처리 하라")
                                vm.getAlarms()
                                self.presentationMode.wrappedValue.dismiss()
                                return
                            }
                            //save alarm
                            if(!repeatDays.isEmpty){
                                var weekDayFireAtSet:[Date] = []
                                let components = Calendar.current.dateComponents([.hour, .minute, .year], from: fireAt)
                                for repeatDay in repeatDays {
                                    weekDayFireAtSet.append(createDate(weekday: repeatDay.intName,
                                                                       hour:components.hour!,
                                                                       minute:components.minute! ,
                                                                       year: components.year!
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
                        }, label:{
                            Text("완료").padding()
                        })
                    }
                    //데이트 피커
                    if(isDay == true){
                        DatePicker("", selection: $fireAt, in: DaydateClosedRange, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel).padding()
                    }else{
                        DatePicker("", selection: $fireAt, in: NightdateClosedRange, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel).padding()
                    }
                    
                    
                    //요일 반복
                    RepeatDaysSettingView(repeatDays: $repeatDays).padding()
                    
                    TextField("알람의 이름을 입력하시오", text: $tagName).padding().textFieldStyle(.roundedBorder)
                    
                    NavigationLink(destination: RecordingsList(audioRecorder: audioRecorder,audioName:$audioName, audioURL:$audioURL)) {
                        Text("현재 목소리 : \(audioName)").foregroundColor(.black)
                        Spacer()
                        Text("목소리 고르기").bold()
                    }.padding()
                

                    //@@@@@@@@@<< recorder  >>@@@@@@@@@@@@@@//
                    //volume slider
                    Slider(value: $volume, in: 0...20, step: 0.1).padding()
                    
                    if(audioRecorder.recording == true){
                        Image(systemName: "waveform.path").font(.system(size: 40, weight: .bold)).foregroundColor(.red)
                    }else{
                        Image(systemName: "waveform.path.ecg").font(.system(size: 40, weight: .bold)).foregroundColor(.black)
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
                            }.padding()
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
                            }.padding()
                        }
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
                                .padding(.bottom, 40)
                        }.padding()
                    }
                    Spacer()
                }//vstack end
            }//scroll view end
            .textFieldAlert(isShowing: $isShowingAlart, text: $fileName, title: "녹음 파일 이름을 입력하세오")
            .playBackAlert(isShowing: $isPlayBack, audioPlayer: self.audioPlayer, audioURL: $audioURL)
            .navigationBarHidden(true)
        }//navi view end
    }
}

//struct AlarmSetting_Previews: PreviewProvider {
//    static var previews: some View {
//        AlarmSetting()
//    }
//}
