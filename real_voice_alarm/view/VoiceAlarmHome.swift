//
//  ContentView.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/25.
//

import SwiftUI

struct VoiceAlarmHome: View {
    @EnvironmentObject var vm: VoiceAlarmHomeViewModel
    @ObservedObject var recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("Filter40A")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    ScrollView{
                        VStack{
                            //conditional Screen
                            if recorderAlarm.isFiring == true {
                                AlarmingScreen()
                            }else {
                                //home
                                Text("다음 알람까지").font(.system(size: 30, weight: .semibold)).foregroundColor(Color.white)
                                
                                if(recorderAlarm.day != 0){
                                    Text("\(recorderAlarm.day)일 남았습니다.").font(.system(size: 35, weight: .bold)).foregroundColor(Color.white)
                                }else{
                                    if(recorderAlarm.hour == 0){
                                        Text("\(recorderAlarm.minute)분 남았습니다.").font(.system(size: 35, weight: .bold)).foregroundColor(Color.white)
                                    }else{
                                        Text("\(recorderAlarm.hour)시간 \(recorderAlarm.minute)분 남았습니다.").font(.system(size: 35, weight: .bold)).foregroundColor(Color.white)
                                    }
                                    
                                }
                                
                                AlarmCardView(alarms: $vm.dayAlarms, isDay: true)
                                AlarmCardView(alarms: $vm.nightAlarms, isDay: false)
                                    .onAppear(perform: {
                                        vm.getAlarms()
                                    })
                            }
                        }
                    }
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
