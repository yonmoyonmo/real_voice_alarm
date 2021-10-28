//
//  AlarmSetting.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import SwiftUI

struct AlarmSetting: View {
    
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder()
    
    let recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    
    @State var tagName: String = ""
    @State var fireAt: Date = Date()
    @State var audioName: String?
    
    
    var body: some View {
        VStack {
            TextField("Enter Alarm Name", text: $tagName).padding().textFieldStyle(.roundedBorder)
            DatePicker("", selection: $fireAt, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
            
            //요일 반복은 아직 구현 안할 것임.
            if audioRecorder.recording == false {
                Button(action: {
                    audioRecorder.startRecording(title: "\(tagName)")
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
                    audioName = audioRecorder.stopRecording()
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
            //레코딩 버튼임
            
            RecordingsList(audioRecorder: audioRecorder)
            
            Button(action: {
                //save alarm
                recorderAlarm.saveAlarm(tagName: tagName,
                                        fireAt: fireAt,
                                        audioName: audioName ?? "default")
            }) {
                Text("save alarm").bold()
            }
        }.padding(20)
    }
}

struct AlarmSetting_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSetting()
    }
}
