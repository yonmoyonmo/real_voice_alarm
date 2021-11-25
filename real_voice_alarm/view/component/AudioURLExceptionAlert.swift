//
//  AudioURLExceptionAlert.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/25.
//

import Foundation
import SwiftUI

struct AudioURLExceptionAlert<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    let presenting: Presenting

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text("목소리 없인 알람을 만들 수 없어요!")
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("넵")
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
