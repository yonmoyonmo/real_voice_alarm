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
    
    let recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    
    @State var tagName: String = "default tag name"
    @State var fireAt: Date = Date()
    @State var repeatDays: [RepeatDays] = []
    
    @State var audioName: String?
    @State var audioURL: URL?
    @State var fileName: String = "default file name"
    @State private var volume: Double = 10
    
    @State var audioData:[String: Any] = [:]
    
    //예외처리 잔뜩 해야한다.
    //파일 이름과 알람 태그도 분리해야한다.
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
                                                          audioName: audioName ?? "default",
                                                          audioURL: audioURL!,
                                                          volume: volume,
                                                          repeatingDays : repeatDays)
                        vm.getAlarms()
                        self.presentationMode.wrappedValue.dismiss()
                    }else{
                        recorderAlarm.saveAlarm(tagName: tagName,
                                                fireAt: fireAt,
                                                audioName: audioName ?? "default",
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
            
            //요일반복을 어케할 것인가? 일단 저장은 한다.
            RepeatDaysSettingView(repeatDays: $repeatDays)
            HStack{
                ForEach(repeatDays, id: \.self) { day in
                    Text("\(day.rawValue)")
                }
            }
            
            TextField("알람의 이름을 입력하시오", text: $tagName).padding().textFieldStyle(.roundedBorder)
            
            
            //volume slider
            Slider(value: $volume, in: 0...20, step: 0.1).padding()
            
            //debug
            //Text("\(volume)")
            
            //recorder
            TextField("녹음 파일의 이름을 입력하시오", text: $fileName).padding().textFieldStyle(.roundedBorder)
            if audioRecorder.recording == false {
                Button(action: {
                    audioRecorder.startRecording(title: "\(fileName)")
                }) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            }else{
                Button(action: {
                    audioData = audioRecorder.stopRecording()
                    audioName = audioData["audioName"] as? String
                    audioURL = audioData["audioFilename"] as? URL
                }) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            }
            RecordingsList(audioRecorder: audioRecorder)
        }.padding(20)
    }
}

struct AlarmSetting_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSetting(vm:VoiceAlarmHomeViewModel())
    }
}
