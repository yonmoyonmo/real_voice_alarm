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
                Text("DEMO 01 | 2021-10-28 ~ ??").padding()
                if recorderAlarm.isFiring == true {
                    AlarmingScreen()
                }else {
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(){
                            ForEach(vm.alarms){alarm in
                                VStack(alignment: .leading) {
                                    Text(alarm.tagName ?? "shithole").padding()
                                    Text(alarm.audioName ?? "shit").padding()
                                    Text(alarm.uuid?.uuidString ?? "shshsit").padding()
                                }
                                .padding()
                                .border(Color.green)
                                
                            }
                        }
                    }).onAppear(perform: {
                        vm.getAlarms()
                    })
                    NavigationLink(destination: AlarmSetting()){
                        Text("알람 맨들기")
                    }.padding()
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
