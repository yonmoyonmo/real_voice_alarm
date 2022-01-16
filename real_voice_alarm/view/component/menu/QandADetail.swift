//
//  QandADetail.swift
//  real_voice_alarm
//
//  Created by yonmo on 2022/01/16.
//

import SwiftUI

struct QandADetail: View {
    let title:String
    let content01:String
    let content02:String
    let content03:String
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
            
            VStack(alignment:.leading){
                Text(title).font(.system(size: 19, weight: .bold)).foregroundColor(Color.textBlack).lineSpacing(15).padding()
                
                Text(content01).font(.system(size: 16, weight: .regular)).foregroundColor(Color.textBlack).lineSpacing(15).padding()
                
                Text(content02).font(.system(size: 16, weight: .regular)).foregroundColor(Color.textBlack).lineSpacing(15).padding()
                
                Text(content03).font(.system(size: 16, weight: .regular)).foregroundColor(Color.textBlack).lineSpacing(15).padding()
            }.frame(width: UIScreen.screenWidth)
            .navigationBarHidden(true)
        }
    }
}

