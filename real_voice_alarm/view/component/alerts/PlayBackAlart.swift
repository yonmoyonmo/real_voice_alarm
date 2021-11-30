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
    
    @State var input:String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.presenting.disabled(isShowing)
                VStack {
                    TextField("녹음 파일의 이름을 입력하시오", text: self.$input).textFieldStyle(.roundedBorder).font(.system(size:20))
                    
                    Divider()
                    Text("방금 녹음한거 들어보기").foregroundColor(Color.textBlack).font(.system(size:18, weight: .bold))
                    
                    HStack{
                        Button(action: {
                            if(audioPlayer.isPlaying == false){
                                audioPlayer.startPlayback(audio: self.audioURL!)
                            }
                        }){
                            Image(systemName: "play.circle").foregroundColor(Color.textBlack).font(.system(size:60, weight: .bold))
                        }.padding()
                        Spacer()
                        Button(action: {
                            if(audioPlayer.isPlaying == true){
                                audioPlayer.stopPlayback()
                            }
                        }){
                            Image(systemName: "stop.fill").foregroundColor(Color.textBlack).font(.system(size:60, weight: .bold))
                        }.padding()
                    }
                    
                    Divider()
                    HStack {
                        Button(action: {
                            audioName = input
                            if(audioName == ""){
                                audioName = "제목 없음_\(Date()).m4a"
                            }
                            let audioData = audioRecorder.changeAudioFileName(audioName: audioName, audioURL: audioURL)
                            audioName = audioData["audioNewName"] as! String
                            audioURL = audioData["audioNewURL"] as? URL
                            
                            input = ""
                            audioRecorder.fatchRecordings()
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("확인").foregroundColor(Color.textBlack).font(.system(size:18, weight: .bold))
                        }
                        Spacer()
                        Button(action: {
                            let audioData = audioRecorder.changeAudioFileName(audioName: audioName, audioURL: audioURL)
                            audioName = audioData["audioNewName"] as! String
                            audioURL = audioData["audioNewURL"] as? URL
                            
                            input = ""
                            audioRecorder.fatchRecordings()
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("취소").foregroundColor(Color.textBlack).font(.system(size:18, weight: .bold))
                        }
                    }.padding()
                }
                .padding()
                .background(Color.mainGrey)
                .frame(
                    width: geometry.size.width*0.9,
                    height: geometry.size.height*0.9
                )
                .opacity(self.isShowing ? 1 : 0)
                
            }
        }
    }
}
