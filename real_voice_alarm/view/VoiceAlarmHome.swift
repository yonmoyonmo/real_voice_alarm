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
    
    let audioPlayer = AudioPlayer.instance
    
    let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    
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
                        }.frame(width: CGFloat(geometry.size.width * 0.85), height: CGFloat(geometry.size.width * 0.2), alignment: .center)
                        
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
            }.background(
                Image("Filter40A")
                    .resizable()
                    .aspectRatio(geometry.size.width, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
        }.onAppear{
            //audioPlayer.checkIfSilence()
            print("home rendered")
        }
        .onChange(of: scenePhase, perform:{ phase in
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

struct VoiceAlarmHome_Previews: PreviewProvider {
    static var previews: some View {
        VoiceAlarmHome().environmentObject(RecorderAlarm())
    }
}
