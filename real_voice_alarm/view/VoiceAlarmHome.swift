//
//  ContentView.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/25.
//

import SwiftUI

struct VoiceAlarmHome: View {
    @StateObject var vm = VoiceAlarmHomeViewModel()
    @ObservedObject var recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    
    var body: some View {
        NavigationView {
            VStack{
                //conditional Screen
                if recorderAlarm.isFiring == true {
                    AlarmingScreen()
                }else {
                    //home
                    Text("다음 알람까지 남은 시간 들어가는 곳").padding()
                    
                    AlarmCardView(alarms: vm.alarms)
                    AlarmCardView(alarms: vm.alarms)
                        .onAppear(perform: {
                            vm.getAlarms()
                        })
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
