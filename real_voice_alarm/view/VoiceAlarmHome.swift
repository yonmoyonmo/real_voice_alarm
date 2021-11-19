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
            VStack{
                //conditional Screen
                if recorderAlarm.isFiring == true {
                    AlarmingScreen()
                }else {
                    //home
                    Text("\(recorderAlarm.day)일 \(recorderAlarm.hour)시간, \(recorderAlarm.minute)분 남음").padding()
                    
                    AlarmCardView(alarms: $vm.dayAlarms)
                    AlarmCardView(alarms: $vm.nightAlarms)
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
