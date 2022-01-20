//
//  RecordingList.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import SwiftUI

struct RecordingsList: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel:VoiceAlarmHomeViewModel
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer.instance
    @Binding var audioName:String
    @Binding var audioURL:URL?
    
    @State var showAlert:Bool = false
    
    var body: some View {
        VStack {
            HStack(){
                Text("Motivoice").foregroundColor(Color.myAccent)
                Spacer()
                Button(action: {
                    audioPlayer.stopPlayback()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("완료").foregroundColor(Color.textBlack)
                })
            }.padding()
            List {
                Section(header: Text("나의 모티보이스")){
                    ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                        RecordingRow(audioURLforShow: recording.fileURL, audioURLforSave: $audioURL, audioName: $audioName)
                    }.onDelete(perform: delete)
                }
                Section(header: Text("기본 모티보이스")){
                    ForEach(audioRecorder.samples, id: \.sampleName){ sample in
                        let sampleURL = URL(string: sample.sampleURL)!
                        SampleRow(audioURLforShow: sampleURL, audioSampleStruct: sample, audioURLforSave: $audioURL, audioName: $audioName)
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
        .audioURLExceptionAlert(isShowing: $showAlert, message: "알림으로 설정된 목소리는 지울 수 없습니다.")
        .onAppear(perform: {
            audioRecorder.fatchRecordings()
        })
        
    }
    
    func delete(at offsets: IndexSet){
        var urlsToDelete = [URL]()
        
        let dayAlarms = viewModel.dayAlarms
        let nightAlarms = viewModel.nightAlarms
        var audioNames:[String] = []
        var canDelete:Bool = true
        
        for dayAlarm in dayAlarms {
            audioNames.append(dayAlarm.audioName!)
        }
        for nightAlarm in nightAlarms {
            audioNames.append(nightAlarm.audioName!)
        }
        
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        let urlString = urlsToDelete[0].path
        
        for otherAudioName in audioNames {
            print("url String : \(urlString) \n audioName : \(otherAudioName)")
            if(urlString.contains(otherAudioName)){
                canDelete = false
            }
            if(urlString.contains(self.audioName)){
                canDelete = false
            }
        }
        if(canDelete == false){
            print("지울 수 없음")
            showAlert.toggle()
            return
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingRow: View{
    @Environment(\.presentationMode) var presentationMode
    
    var audioURLforShow: URL
    
    @Binding var audioURLforSave: URL?
    @Binding var audioName:String
    
    @ObservedObject var audioPlayer = AudioPlayer.instance
    
    var body: some View{
        HStack{
            Button(action: {
                audioURLforSave = audioURLforShow
                audioName = audioURLforShow.lastPathComponent
                audioPlayer.stopPlayback()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("\(audioURLforShow.lastPathComponent)").foregroundColor(.textBlack)
            })
                
            Spacer()
            if audioPlayer.isPlaying == false {
                Image(systemName: "play.circle").imageScale(.large).foregroundColor(.textBlack)
                    .onTapGesture {
                        audioPlayer.startPlayback(audio: self.audioURLforShow)
                    }
            }else{
                Image(systemName: "stop.fill").imageScale(.large).foregroundColor(.textBlack)
                    .onTapGesture {
                        audioPlayer.stopPlayback()
                    }
                
            }
        }
        
    }
}




struct SampleRow: View{
    @Environment(\.presentationMode) var presentationMode
    
    var audioURLforShow: URL
    let audioSampleStruct: Sample
    
    @Binding var audioURLforSave: URL?
    @Binding var audioName:String
    
    @ObservedObject var audioPlayer = AudioPlayer.instance
    
    var body: some View{
        HStack{
            Button(action: {
                audioURLforSave = audioURLforShow
                audioName = audioURLforShow.lastPathComponent
                audioPlayer.stopPlayback()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("\(audioSampleStruct.sampleName)").foregroundColor(.textBlack)
            })
            
            Spacer()
            if audioPlayer.isPlaying == false {
                Image(systemName: "play.circle").imageScale(.large).foregroundColor(.textBlack)
                    .onTapGesture {
                        audioPlayer.startPlayback(audio: self.audioURLforShow)
                    }
            }else{
                Image(systemName: "stop.fill").imageScale(.large).foregroundColor(.textBlack)
                    .onTapGesture {
                        audioPlayer.stopPlayback()
                    }
                
            }
        }
    }
}


