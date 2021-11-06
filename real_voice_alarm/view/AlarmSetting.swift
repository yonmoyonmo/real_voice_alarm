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
    
    func createDate(weekday: Int, hour: Int, minute: Int, year: Int)->Date{
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.year = year
        components.weekday = weekday // sunday = 1 ... saturday = 7
        components.weekdayOrdinal = 10
        components.timeZone = .current
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)!
    }
    
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("취소").foregroundColor(.black)
                    }
                    Spacer()
                    
                    //완료 버튼 : 알람 데이터 저장 + 스케쥴링
                    Button(action: {
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
                        Text("완료").bold()
                    }}
                
                
                DatePicker("", selection: $fireAt, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                
                //요일 반복
                RepeatDaysSettingView(repeatDays: $repeatDays)
                
                TextField("알람의 이름을 입력하시오", text: $tagName).padding().textFieldStyle(.roundedBorder)
                
                
                //volume slider
                Slider(value: $volume, in: 0...20, step: 0.1).padding()
                
                NavigationLink(destination: RecordingsList(audioRecorder: audioRecorder,audioName:$audioName, audioURL:$audioURL)) {
                    Text("현재 목소리 : \(audioName)").foregroundColor(.black)
                    Spacer()
                    Text("목소리 고르기").bold()
                }
                
                
                //recorder
                if(audioRecorder.recording == true){
                    Image(systemName: "waveform.path").font(.system(size: 56.0, weight: .bold)).foregroundColor(.red)
                }else{
                    Image(systemName: "waveform.path.ecg").font(.system(size: 56.0, weight: .bold)).foregroundColor(.black)
                }
                
                Text("새로 하나 녹음하려면 아래 버튼을 누르시오")
                
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
                        isPlayBack.toggle()
                    }) {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }.onAppear(perform: {
                        audioName = audioData["audioName"] as! String
                        audioURL = audioData["audioURL"] as? URL
                    })
                }
                
            }.padding(20)
        }
        .textFieldAlert(isShowing: $isShowingAlart, text: $fileName, title: "녹음 파일 이름을 입력하세오")
        .playBackAlert(isShowing: $isPlayBack, audioPlayer: self.audioPlayer, audioURL: $audioURL)
    }
}
struct PlayBackAlart<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    @Binding var audioURL: URL?

    let presenting: Presenting
    
    let audioPlayer: AudioPlayer
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text("방금 녹음한거 들어보기")
                    
                    if audioPlayer.isPlaying == false {
                        Button(action: {
                            print("playing")
                            audioPlayer.startPlayback(audio: self.audioURL!)
                        }){
                            Image(systemName: "play.circle").imageScale(.medium).font(.system(size: 30.0, weight: .bold))
                        }
                    }else{
                        Button(action: {
                            print("stop playing")
                            audioPlayer.stopPlayback()
                        }){
                            Image(systemName: "stop.fill").imageScale(.medium).font(.system(size: 30.0, weight: .bold))
                        }
                    }
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("다 들음")
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

struct TextFieldAlert<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(self.title)
                    TextField("녹음 파일의 이름을 입력하시오", text: self.$text)
                    Divider()
                    HStack {
                        if(text != "default"){
                            Button(action: {
                                withAnimation {
                                    self.isShowing.toggle()
                                }
                            }) {
                                Text("다 입력함")
                            }
                        }else{
                            Button(action: {
                            }) {
                                Text("이름을 지어주셈")
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
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
