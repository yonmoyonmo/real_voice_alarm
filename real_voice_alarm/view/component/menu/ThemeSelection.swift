//
//  ThemeSelection.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/12/19.
//

import SwiftUI

struct ThemeSelection: View {
    @Binding var themeType:String
    @Binding var cardType:String
    
    let themeA:String = "Filter40A"
    let themeB:String = "Filter40B"
    let themeC:String = "Filter40C"
    
    let cardA:String = "CardA"
    let cardB:String = "CardB"
    let cardC:String = "CardC"
    
    let themeKey:String = "themeType"
    let cardKey:String = "cardType"
    
    
    var body: some View {
        ScrollView{
            VStack{
                Text("테마를 터치하여 선택할 수 있습니다.")
                GroupBox{
                    HStack{
                        Button(action:{
                            UserDefaults.standard.set(themeA, forKey: themeKey)
                            UserDefaults.standard.set(cardA, forKey: cardKey)
                            themeType = themeA
                            cardType = cardA
                        }) {
                            Image("FrameA").resizable().scaledToFit().frame(width: 100,height: 150)
                        }
                        Button(action:{
                            UserDefaults.standard.set(themeB, forKey: themeKey)
                            UserDefaults.standard.set(cardB, forKey: cardKey)
                            themeType = themeB
                            cardType = cardB
                        }) {
                            Image("FrameB").resizable().scaledToFit().frame(width: 100,height: 150)
                        }
                        Button(action:{
                            UserDefaults.standard.set(themeC, forKey: themeKey)
                            UserDefaults.standard.set(cardC, forKey: cardKey)
                            themeType = themeC
                            cardType = cardC
                        }) {
                            Image("FrameC").resizable().scaledToFit().frame(width: 100,height: 150)
                        }
                    }
                }
            }
            .navigationTitle(Text("테마 변경"))
        }
        .frame(width: CGFloat(UIScreen.screenWidth), alignment: .center)
            .background(
                Image(themeType).resizable().aspectRatio(UIScreen.screenWidth, contentMode: .fill).edgesIgnoringSafeArea(.all)
            )
        
    }
}


