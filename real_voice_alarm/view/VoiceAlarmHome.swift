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
                    SwiftUIBannerAd(adPosition: .top, adUnitId: "ca-app-pub-3940256099942544/2934735716")
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
                                if(recorderAlarm.minute == 0){
                                    Text("  다음 알람까지 \n \(recorderAlarm.day)일 남았습니다.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                }else{
                                    if(recorderAlarm.hour == 0){
                                        if(recorderAlarm.minute < 0){
                                            Text("  다음 알람까지 \n 0분 남았습니다.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                        }else{
                                            Text("  다음 알람까지 \n \(recorderAlarm.minute)분 남았습니다.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                        }
                                    }else if(recorderAlarm.minute != 0 && recorderAlarm.day == 1){
                                        Text("  다음 알람까지 \n \(recorderAlarm.day)일 \(recorderAlarm.hour)시간 \(recorderAlarm.minute)분 남았습니다.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                    }else{
                                        Text("  다음 알람까지 \n \(recorderAlarm.hour)시간 \(recorderAlarm.minute)분 남았습니다.").font(.system(size: 23, weight: .bold)).foregroundColor(Color.white)
                                    }
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
                imageName: "speaker.slash.fill",
                description: "1",
                showBotton: false
            )
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "mic.fill",
                description: "2",
                showBotton: false
            )
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "mic.fill",
                description: "3",
                showBotton: false
            )
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "mic.fill",
                description: "4",
                showBotton: false
            )
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "hand.raised",
                description: "5",
                showBotton: true
            )
        }.tabViewStyle(PageTabViewStyle())
            .background(Image("Filter40A").resizable().scaledToFill())
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
            GroupBox{
                Image(systemName: imageName)
                    .font(.system(size: 60))
                    .padding()
                
                Text(description).font(.system(size:20,weight: .bold)).padding()
                
                if(showBotton){
                    Button{
                        showOnboard.toggle()
                        UserDefaults.standard.set(false, forKey: "doUserWantOnboardingView")
                    }label: {
                        Text("다시 보지 않겠습니다.")
                            .font(.system(size: 18))
                            .frame(maxWidth: 270)
                            .foregroundColor(.black)
                            .padding()
                    }.background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .opacity(0.8)
                        .shadow(radius: 5, x: 0, y: 5)
                        .padding()
                    
                    Button{
                        showOnboard.toggle()
                        //UserDefaults.standard.set(false, forKey: "doUserWantOnboardingView")
                    }label: {
                        Text("나중에 다시 보겠습니다.")
                            .font(.system(size: 18))
                            .frame(maxWidth: 270)
                            .foregroundColor(.black)
                            .padding()
                    }.background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .opacity(0.8)
                        .shadow(radius: 5, x: 0, y: 5)
                        .padding()
                }
            }.frame(width: UIScreen.screenWidth, alignment: .center)
        }
    }
}
