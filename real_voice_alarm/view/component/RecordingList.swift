//
//  RecordingList.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import SwiftUI

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var audioName:String
    @Binding var audioURL:URL?
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURLforShow: recording.fileURL, audioURLforSave: $audioURL, audioName: $audioName)
            }.onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet){
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
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



