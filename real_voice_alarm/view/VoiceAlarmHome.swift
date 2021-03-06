//
//  ContentView.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/25.
//

import SwiftUI

struct VoiceAlarmHome: View {
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var vm: VoiceAlarmHomeViewModel
    @ObservedObject var recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    
    let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    
    @State var showingOnboardingView:Bool = UserDefaults.standard.bool(forKey: "doUserWantOnboardingView")
    @State var showMenu:Bool = false
    
    @State var themeType:String = UserDefaults.standard.string(forKey: "themeType")!
    @State var cardType:String = UserDefaults.standard.string(forKey: "cardType")!
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                ZStack{
                    SwiftUIBannerAd(adPosition: .top, adUnitId: "ca-app-pub-8227009639656125/4444801060")
                    VStack{
                        //conditional Screen
                        if recorderAlarm.isFiring == true {
                            AlarmingScreen()
                        }else {
                            //home
                            Group{
                                Spacer()
                                HStack{
                                    Spacer()
                                    Button(action:{
                                        showMenu.toggle()
                                    }) {
                                        Image(systemName:"gearshape.fill")
                                            .font(.system(size: 25))
                                            .foregroundColor(.white)
                                    }.sheet(isPresented: self.$showMenu) {
                                        HomeMenu(themeType: $themeType, cardType:$cardType)
                                    }
                                }
                                if(recorderAlarm.day == 0 && recorderAlarm.hour == 0 && recorderAlarm.minute == 0){
                                    Text("  ?????? ????????? ????????????.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                }else{
                                    if(recorderAlarm.day > 1){
                                        Text("  ?????? ???????????? \n \(recorderAlarm.day)??? ???????????????.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                    }else{
                                        if(recorderAlarm.hour == 0){
                                            if(recorderAlarm.minute < 0){
                                                Text("  ?????? ???????????? \n 0??? ???????????????.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                            }else{
                                                Text("  ?????? ???????????? \n \(recorderAlarm.minute)??? ???????????????.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                            }
                                        }else if(recorderAlarm.minute != 0 && recorderAlarm.day == 1){
                                            Text("  ?????? ???????????? \n \(recorderAlarm.day)??? \(recorderAlarm.hour)?????? \(recorderAlarm.minute)??? ???????????????.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                        }else{
                                            Text("  ?????? ???????????? \n \(recorderAlarm.hour)?????? \(recorderAlarm.minute)??? ???????????????.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                if(vm.isFull){
                                    Text("????????? 10????????? ?????? ??? ????????????. \n????????? 10?????? ?????? ???????????????.").font(.system(size: 12, weight: .bold)).foregroundColor(Color.white)
                                }
                                Spacer()
                            }.frame(width: CGFloat(geometry.size.width * 0.85),
                                    height: UIScreen.screenHeight > 1000.0 ?
                                    CGFloat(geometry.size.width * 0.1) : CGFloat(geometry.size.width * 0.15),
                                    alignment: .center)
                            
                            Group{
                                AlarmCardView(alarms: $vm.dayAlarms, isDay: true, cardType: self.cardType, themeType: self.themeType)
                                AlarmCardView(alarms: $vm.nightAlarms, isDay: false, cardType: self.cardType, themeType: self.themeType)
                                    .onAppear(perform: {
                                        vm.getAlarms()
                                    }).onReceive(timer){ time in
                                        recorderAlarm.setLastingTimeOfNext()
                                    }
                            }.padding(.leading, 5)
                        }
                    }
                }
                
            }
            .background(
                Image(themeType)
                    .resizable()
                    .aspectRatio(geometry.size.width, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            ).fullScreenCover(isPresented: $showingOnboardingView){
                OnboardingView(showOnboarding: $showingOnboardingView)
            }
        }.onChange(of: scenePhase, perform:{ phase in
            switch phase{
            case .active:
                DispatchQueue.main.async {
                    recorderAlarm.checkCurrentDeliverdAlarmId()
                }
            case .background:
                print("app goes to background")
            case .inactive:
                print("app is now inactive")
            @unknown default: print("ScenePhase: unexpected state")
            }
        })
    }
}

struct OnboardingView: View {
    @Binding var showOnboarding:Bool
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    var body: some View{
        TabView{
            
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "theIconWLogo",
                description: "?????? ??????????????? ?????????,\n????????????????????????.",
                showBotton: false)
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "OBMain01",
                description: "?????? ????????? ?????????\n????????? ?????? ?????? ??????",
                showBotton: false)
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "OBMain02",
                description: "?????? ?????? ?????????\n????????? ?????? ?????? ?????????",
                showBotton: false)
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "OBMain03",
                description: "????????? ???????????? ??????????????????,\n????????? ????????? ???\n???????????? ???????????? ?????? ?????? ?????????!",
                showBotton: false)
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "silenceWBell",
                description: "??????????????? ?????????????????????\n?????? ????????????!\n????????? ????????? ?????????...",
                showBotton: false)
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "campFire",
                description: "?????? ???????????? ?????????\n?????? ??????\n\n????????? ?????????\n???????????? ???????????????",
                showBotton: true)
            
        }.tabViewStyle(PageTabViewStyle())
            .background(
                Image("Filter40A")
                    .resizable()
                    .aspectRatio(UIScreen.screenWidth, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
            .onAppear {
                setupAppearance()
            }
    }
}

struct OnboardingPageView:View {
    @Binding var showOnboard:Bool
    let imageName:String
    let description:String
    let showBotton:Bool
    
    var body: some View{
        VStack{
            Image(imageName).resizable().scaledToFit()
                .frame(width: UIScreen.screenWidth*0.6, height: UIScreen.screenHeight*0.5)
                .padding()
            
            Text(description).font(.system(size: 20, weight: .bold)).foregroundColor(Color.textBlack).lineSpacing(10)
                .frame(width: UIScreen.screenWidth*0.9,alignment: .center)
                .multilineTextAlignment(.center)
            
            if(showBotton){
                Button{
                    showOnboard.toggle()
                    UserDefaults.standard.set(false, forKey: "doUserWantOnboardingView")
                }label: {
                    Text("??????")
                        .frame(width: UIScreen.screenWidth * 0.8, height: 40)
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(Color.white)
                        .padding()
                }.background(Color("campColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .opacity(0.8)
                    .shadow(radius: 5, x: 0, y: 5)
                    .padding()
                
            }
        }
    }
}
