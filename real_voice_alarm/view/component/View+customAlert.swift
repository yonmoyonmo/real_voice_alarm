//
//  View+customAlert.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/08.
//

import Foundation
import SwiftUI

extension View {
    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       presenting: self,
                       title: title)
    }
    
    func playBackAlert(isShowing: Binding<Bool>, audioPlayer: AudioPlayer, audioURL:Binding<URL?>) -> some View {
        PlayBackAlart(isShowing: isShowing, audioURL: audioURL, presenting: self, audioPlayer: audioPlayer)
    }
}
