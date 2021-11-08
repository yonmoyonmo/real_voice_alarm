//
//  PlayBackAlart.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/08.
//

import SwiftUI

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
