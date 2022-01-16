//
//  HomeMenu.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/12/19.
//
import SwiftUI

struct HomeMenu: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var showingOnboardingView:Bool = UserDefaults.standard.bool(forKey: "doUserWantOnboardingView")
    
    @Binding var themeType:String
    @Binding var cardType:String
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                VStack {
                    HStack(){
                        Text("MENU").foregroundColor(Color.myAccent)
                        Spacer()
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("완료").foregroundColor(Color.textBlack)
                        })
                    }.padding(.top).padding(.horizontal)
                    List{
                        NavigationLink(destination: GuideList(),label:{
                            Text("이용 가이드").foregroundColor(Color.textBlack)
                        })
                        NavigationLink(destination: QandAList(),label:{
                            Text("Q&A").foregroundColor(Color.textBlack)
                        })
                        Toggle("앱 실행시 가이드 스크린 보기", isOn: $showingOnboardingView)
                            .onChange(of: showingOnboardingView){ value in
                                UserDefaults.standard.set(showingOnboardingView, forKey: "doUserWantOnboardingView")
                            }
                        
                        NavigationLink(destination: ThemeSelection(themeType: $themeType, cardType: $cardType), label:{
                            Text("앱 테마 바꾸기").foregroundColor(Color.textBlack)
                        })
                    }
                    .cornerRadius(30)
                    .padding(15)
                    
                }
                .frame(width: CGFloat(geometry.size.width), alignment: .center)
                .background(
                    Image(themeType).resizable()
                        .aspectRatio(geometry.size.width, contentMode: .fill).edgesIgnoringSafeArea(.all))
                .navigationBarHidden(true)
            }.accentColor(.textBlack)
        }
    }
}
