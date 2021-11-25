//
//  PlayBackAlart.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/08.
//

import SwiftUI
import Combine

struct PlayBackAlart<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    @Binding var audioURL: URL?
    @Binding var audioName:String
    
    let presenting: Presenting
    
    let audioPlayer: AudioPlayer
    let audioRecorder: AudioRecorder = AudioRecorder.instance
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting.disabled(isShowing)
                VStack {
                    TextField("녹음 파일의 이름을 입력하시오", text: self.$audioName).padding().textFieldStyle(.roundedBorder)
                    
                    Divider()
                    Text("방금 녹음한거 들어보기").foregroundColor(Color.accentColor)
                    HStack{
                        Button(action: {
                            if(audioPlayer.isPlaying == false){
                                audioPlayer.startPlayback(audio: self.audioURL!)
                            }
                        }){
                            Image(systemName: "play.circle").imageScale(.medium).font(.system(size: 30.0, weight: .bold))
                        }.padding()
                        Button(action: {
                            if(audioPlayer.isPlaying == true){
                                audioPlayer.stopPlayback()
                            }
                        }){
                            Image(systemName: "stop.fill").imageScale(.medium).font(.system(size: 30.0, weight: .bold))
                        }.padding()
                    }
                    Divider()
                    HStack {
                        Button(action: {
                            let audioData = audioRecorder.changeAudioFileName(audioName: audioName, audioURL: audioURL)
                            audioName = audioData["audioNewName"] as! String
                            audioURL = audioData["audioNewURL"] as? URL
                            
                            audioRecorder.fatchRecordings()
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("저장")
                        }
                    }
                }
                .padding()
                .background(Color.mainGrey)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.9
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
                
            }
        }
    }
}
