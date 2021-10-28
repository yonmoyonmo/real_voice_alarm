//
//  ContentView.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/25.
//

import SwiftUI

struct VoiceAlarmHome: View {
    @StateObject var vm = VoiceAlarmHomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                Text("DEMO 01 | 2021-10-28")
                
                ScrollView(.horizontal, showsIndicators: true, content: {
                    HStack(){
                        ForEach(vm.alarms){alarm in
                            Text(alarm.tagName ?? "shithole").padding()
                        }
                    }
                }).onAppear(perform: {
                    vm.getAlarms()
                })
                
                
                NavigationLink(destination: AlarmSetting()){
                    Text("알람 맨들기").padding(20)
                }
            }.padding(20)
        }
    }
}

struct VoiceAlarmHome_Previews: PreviewProvider {
    static var previews: some View {
        VoiceAlarmHome()
    }
}
