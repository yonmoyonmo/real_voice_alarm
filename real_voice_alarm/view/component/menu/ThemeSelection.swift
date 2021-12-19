//
//  ThemeSelection.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/12/19.
//

import SwiftUI

struct ThemeSelection: View {
    let themeA:String = "Filter40A"
    let themeB:String = "Filter40B"
    let themeC:String = "Filter40C"
    
    let cardA:String = "CardA"
    let cardB:String = "CardB"
    let cardC:String = "CardC"
    
    let themeKey:String = "themeType"
    let cardKey:String = "cardType"
    
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    UserDefaults.standard.set(themeA, forKey: themeKey)
                    UserDefaults.standard.set(cardA, forKey: cardKey)
                }) {
                    Image("FrameA").resizable()
                        .frame(width: 100, height: 200)
                }
                Spacer()
                Text("고르기")
            }
            HStack{
                Button(action:{
                    UserDefaults.standard.set(themeB, forKey: themeKey)
                    UserDefaults.standard.set(cardB, forKey: cardKey)
                }) {
                    Image("FrameB").resizable()
                        .frame(width: 100, height: 200)
                }
                Spacer()
                Text("고르기")
            }
            HStack{
                Button(action:{
                    UserDefaults.standard.set(themeC, forKey: themeKey)
                    UserDefaults.standard.set(cardC, forKey: cardKey)
                }) {
                    Image("FrameC").resizable()
                        .frame(width: 100, height: 200)
                }
                Spacer()
                Text("고르기")
            }
        }.padding()
            .navigationBarHidden(true)
    }
}

struct ThemeSelection_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelection()
    }
}
