//
//  RecordingList.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import SwiftUI

struct RecordingsList: View {
    @EnvironmentObject var viewModel:VoiceAlarmHomeViewModel
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var audioName:String
    @Binding var audioURL:URL?
    
    @State var showAlert:Bool = false
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURLforShow: recording.fileURL, audioURLforSave: $audioURL, audioName: $audioName)
            }.onDelete(perform: delete)
        }
        .audioURLExceptionAlert(isShowing: $showAlert, message: "설정된 알람은 지울 수 없습니다.")
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
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View{
        HStack{
            Text("\(audioURLforShow.lastPathComponent)")
                .onTapGesture {
                    audioURLforSave = audioURLforShow
                    audioName = audioURLforShow.lastPathComponent
                    presentationMode.wrappedValue.dismiss()
                }
            
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    audioPlayer.startPlayback(audio: self.audioURLforShow)
                }){
                    Image(systemName: "play.circle").imageScale(.large)
                }
            }else{
                Button(action: {
                    audioPlayer.stopPlayback()
                }){
                    Image(systemName: "stop.fill").imageScale(.large)
                }
            }
        }
    }
}



