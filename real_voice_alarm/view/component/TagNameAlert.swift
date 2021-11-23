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
                    Text(self.title)
                    TextField("알람의 태그를 입력하세요", text: self.$text)
                    Divider()
                    HStack {
                        if(text != "default"){
                            Button(action: {
                                withAnimation {
                                    self.isShowing.toggle()
                                }
                            }) {
                                Text("다 입력함")
                            }
                        }else{
                            Button(action: {
                            }) {
                                Text("태그네임을 제발 입력하세요 진짜 부탁입니다.")
                            }
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
