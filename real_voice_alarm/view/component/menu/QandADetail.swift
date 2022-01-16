//
//  QandADetail.swift
//  real_voice_alarm
//
//  Created by yonmo on 2022/01/16.
//

import SwiftUI

struct QandADetail: View {
    let title:String
    let content:String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView{
            HStack(){
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("← Back").foregroundColor(Color.textBlack)
                    Spacer()
                })
            }.padding(.top).padding(.horizontal)
            
            VStack{
                Text(title).font(.system(size: 19, weight: .bold)).foregroundColor(Color.textBlack).lineSpacing(15).padding()
                    .frame(width: UIScreen.screenWidth, alignment: .leading)
                
                Text(content).font(.system(size: 16, weight: .regular)).foregroundColor(Color.textBlack).lineSpacing(15).padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }
}

