//
//  HomeMenu.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/12/19.
//

import SwiftUI

struct HomeMenu: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var isUserWantsToSeeGuideAtLaunch:Bool
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                ScrollView{
                    Group{
                        VStack(alignment: .center) {
                            HStack(){
                                Text("MENU").foregroundColor(Color.myAccent)
                                Spacer()
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("완료").foregroundColor(Color.textBlack)
                                })
                            }.padding(10)
                            //menus
                            GroupBox{
                                HStack{
                                    NavigationLink(destination: QandAMenu(), label:{
                                        Text("자주 묻는 질문 보기")
                                    })
                                    Spacer()
                                }.frame(height: 50, alignment: .center)
                                HStack{
                                    Toggle("앱 실행시 가이드 스크린 보기", isOn: $isUserWantsToSeeGuideAtLaunch)
                                        .onChange(of: isUserWantsToSeeGuideAtLaunch){ value in
                                            UserDefaults.standard.set(isUserWantsToSeeGuideAtLaunch, forKey: "doUserWantOnboardingView")
                                        }
                                }.frame(height: 50, alignment: .center)
                                
                                HStack{
                                    NavigationLink(destination: ThemeSelection(), label:{
                                        Text("앱 테마 바꾸기")
                                    })
                                    Spacer()
                                }.frame(height: 50, alignment: .center)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, UIScreen.screenWidth > 700.0 ? 200 : 10)
                    .padding(.top, UIScreen.screenWidth > 700.0 ? 150 : 10)
                }
                .frame(width: CGFloat(geometry.size.width), alignment: .center)
                .background(
                    Image("Filter40A").resizable().aspectRatio(geometry.size.width, contentMode: .fill).edgesIgnoringSafeArea(.all)
                )
                .navigationBarHidden(true)
            }
            
        }
    }
    
}
//struct HomeMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeMenu()
//    }
//}
