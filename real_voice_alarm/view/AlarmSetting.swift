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
    
    @State var tagName: String = ""
    @State var fireAt: Date = Date()
    
    @State var audioName: String?
    @State var audioURL: URL?
    @State var audioData:[String: Any] = [:]
    
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("취소").foregroundColor(.black)
                }
                Spacer()
                Button(action: {
                    //save alarm
                    recorderAlarm.saveAlarm(tagName: tagName,
                                            fireAt: fireAt,
                                            audioName: audioName ?? "default",
                                            audioURL: audioURL!)
                    vm.getAlarms()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("완료").bold()
                }}
            
            DatePicker("", selection: $fireAt, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
            
            TextField("Enter Alarm Name", text: $tagName).padding().textFieldStyle(.roundedBorder)
            
            //recorder
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
