//
//  AlarmSetting.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import SwiftUI

struct AlarmSetting: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder()
    
    let vm:VoiceAlarmHomeViewModel
    
    let audioPlayer: AudioPlayer = AudioPlayer()
    
    let recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    
    @State var tagName: String = "default"
    @State var fireAt: Date = Date()
    @State var repeatDays: [RepeatDays] = []
    
    @State var audioName: String = "default"
    @State var audioURL: URL?
    @State var audioData: [String:Any] = [:]
    
    @State var fileName: String = "default"
    @State var isShowingAlart: Bool = false
    
    @State var isPlayBack: Bool = false
    
    @State private var volume: Double = 10
    
    
    //예외처리 잔뜩 해야한다.
    //일단 이름짓는 것들 길이제한부터
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("취소").foregroundColor(.black).padding()
                    }.border(.black, width: 2.5)
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
                                                                   year: components.year!))
                            }
                            recorderAlarm.saveRepeatingAlarms(tagName: tagName,
                                                              fireAtList: weekDayFireAtSet,
                                                              audioName: audioName,
                                                              audioURL: audioURL!,
                                                              volume: volume,
                                                              repeatingDays : repeatDays)
                            vm.getAlarms()
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
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("완료").bold().padding()
                    }.border(.black, width: 2.5)
                }
                
                DatePicker("", selection: $fireAt, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel).padding().border(.black, width: 2.5)
                
                //요일 반복
                Group {
                    RepeatDaysSettingView(repeatDays: $repeatDays).padding().border(.black, width: 2.5)
                    
                    TextField("알람의 이름을 입력하시오", text: $tagName).padding().textFieldStyle(.roundedBorder)
                    
                    NavigationLink(destination: RecordingsList(audioRecorder: audioRecorder,audioName:$audioName, audioURL:$audioURL)) {
                        Text("현재 목소리 : \(audioName)").foregroundColor(.black)
                        Spacer()
                        Text("목소리 고르기").bold()
                    }.padding().border(.black, width: 2.5)
                }
                
                //@@@@@@@@@<< recorder  >>@@@@@@@@@@@@@@//
                //volume slider
                Slider(value: $volume, in: 0...20, step: 0.1).padding().border(.black, width: 2.5)

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
                    }
                }
            }.padding(20)
        }
        .textFieldAlert(isShowing: $isShowingAlart, text: $fileName, title: "녹음 파일 이름을 입력하세오")
        .playBackAlert(isShowing: $isPlayBack, audioPlayer: self.audioPlayer, audioURL: $audioURL)
    }
}

extension View {
    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       presenting: self,
                       title: title)
    }
    
    func playBackAlert(isShowing: Binding<Bool>, audioPlayer: AudioPlayer, audioURL:Binding<URL?>) -> some View {
        PlayBackAlart(isShowing: isShowing, audioURL: audioURL, presenting: self, audioPlayer: audioPlayer)
    }
}

struct AlarmSetting_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSetting(vm:VoiceAlarmHomeViewModel())
    }
}
