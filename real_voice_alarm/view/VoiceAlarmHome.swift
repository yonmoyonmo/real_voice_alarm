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
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                VStack{
                    //conditional Screen
                    if recorderAlarm.isFiring == true {
                        AlarmingScreen()
                    }else {
                        //home
                        Group{
                            Spacer()
                            if(recorderAlarm.day != 0){
                                Text("  다음 알람까지 \n \(recorderAlarm.day)일 남았습니다.").font(.system(size: 28, weight: .bold)).foregroundColor(Color.white)
                            }else{
                                if(recorderAlarm.hour == 0){
                                    Text("  다음 알람까지 \n \(recorderAlarm.minute)분 남았습니다.").font(.system(size: 28, weight: .bold)).foregroundColor(Color.white)
                                }else{
                                    Text("  다음 알람까지 \n \(recorderAlarm.hour)시간 \(recorderAlarm.minute)분 남았습니다.").font(.system(size: 28, weight: .bold)).foregroundColor(Color.white)
                                }
                            }
                            Spacer()
                        }.frame(width: CGFloat(geometry.size.width * 0.85),
                                height: UIScreen.screenHeight > 1100.0 ?
                                CGFloat(geometry.size.width * 0.1) : CGFloat(geometry.size.width * 0.2),
                                alignment: .center)
                        
                        Group{
                            AlarmCardView(alarms: $vm.dayAlarms, isDay: true)
                            AlarmCardView(alarms: $vm.nightAlarms, isDay: false)
                                .onAppear(perform: {
                                    vm.getAlarms()
                                }).onReceive(timer){ time in
                                    recorderAlarm.setLastingTimeOfNext()
                                }
                        }.padding(.leading, 5)
                    }
                }
            }
            .background(
                Image("Filter40A")
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
                description: "무음모드 하면 안댑니다",
                showBotton: false
            )
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "face.smiling",
                description: "이래저래 잘 쓰십쇼",
                showBotton: false
            )
            OnboardingPageView(
                showOnboard: $showOnboarding,
                imageName: "hand.raised",
                description: "그럼 이만...",
                showBotton: true
            )
        }.tabViewStyle(PageTabViewStyle()).onAppear {
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
            Group{
                Image(systemName: imageName)
                    .font(.system(size: 50))
                Text(description)
            }.frame(width: UIScreen.screenWidth, alignment: .center)
            if(showBotton){
                Button{
                    showOnboard.toggle()
                    UserDefaults.standard.set(false, forKey: "doUserWantOnboardingView")
                }label: {
                    Text("다시 보지 않겠습니다.")
                        .bold()
                        .foregroundColor(Color.textBlack)
                        .frame(width: CGFloat(200), height: CGFloat(50))
                        .background(Color.mainGrey)
                }
                
                Button{
                    showOnboard.toggle()
                    //UserDefaults.standard.set(false, forKey: "doUserWantOnboardingView")
                }label: {
                    Text("나중에 다시 보겠습니다.")
                        .bold()
                        .foregroundColor(Color.textBlack)
                        .frame(width: CGFloat(200), height: CGFloat(50))
                        .background(Color.mainGrey)
                }
            }
        }
    }
}

struct VoiceAlarmHome_Previews: PreviewProvider {
    static var previews: some View {
        VoiceAlarmHome().environmentObject(RecorderAlarm())
    }
}
