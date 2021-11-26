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
    let message:String

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(message).foregroundColor(Color.textBlack).font(.system(size:18, weight: .bold))
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("넵").foregroundColor(Color.textBlack).font(.system(size:18, weight: .bold))
                        }
                    }
                }
                .padding()
                .background(Color.mainGrey)
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
