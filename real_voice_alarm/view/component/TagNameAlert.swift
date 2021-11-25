//
//  tagNameAlert.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/23.
//

import Foundation
import SwiftUI

struct TagNameAlert<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(self.title).font(.system(size:18, weight: .bold))
                    TextField("알람의 태그를 입력하세요", text: self.$text).textFieldStyle(.roundedBorder)
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("OK").foregroundColor(Color.textBlack)
                        }
                        
                        
                        
                    }
                }.padding(30)
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
