//
//  View+customAlert.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/08.
//

import Foundation
import SwiftUI

extension View {
    func playBackAlert(isShowing: Binding<Bool>,
                       audioPlayer: AudioPlayer,
                       audioURL:Binding<URL?>,
                       audioName:Binding<String> ) -> some View {
        PlayBackAlart(isShowing: isShowing,
                      audioURL: audioURL,
                      audioName:audioName,
                      presenting: self,
                      audioPlayer: audioPlayer)
    }
    
    func tagNameAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String) -> some View {
        TagNameAlert(isShowing: isShowing,
                       text: text,
                       presenting: self,
                       title: title)
    }
}
