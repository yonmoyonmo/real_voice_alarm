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
    @State var input:String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Group{
                        Text("알람의 태그를 입력하세요").font(.system(size:18, weight: .bold)).padding()
                        TextField("알람의 태그를 입력하세요", text: self.$input).textFieldStyle(.roundedBorder)
                    }
                    Divider()
                    HStack {
                        Button(action: {
                            text = input
                            if(text == ""){
                                text = "태그 없음"
                            }
                            input = ""
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("확인").foregroundColor(Color.textBlack).font(.system(size:18, weight: .bold))
                        }
                        Spacer()
                        Button(action: {
                            if(text == ""){
                                text = "태그 없음"
                            }
                            input = ""
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("돌아가기").foregroundColor(Color.textBlack).font(.system(size:18, weight: .bold))
                        }
                    }.padding()
                }.padding(30)
                    .background(Color.mainGrey)
                    .frame(
                        width: geometry.size.width*0.9
                    )
                    .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}
