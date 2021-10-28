//
//  RecordingList.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import SwiftUI

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL)
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
    
    var audioURL: URL
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View{
        HStack{
            Text("\(audioURL.lastPathComponent)")
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    print("playing")
                    audioPlayer.startPlayback(audio: self.audioURL)
                }){
                    Image(systemName: "play.circle").imageScale(.large)
                }
            }else{
                Button(action: {
                    print("stop playing")
                    audioPlayer.stopPlayback()
                }){
                    Image(systemName: "stop.fill").imageScale(.large)
                }
            }
        }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}

