//
//  AfterAlarmScreen.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/19.
//

import SwiftUI

struct AfterAlarmScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let recorderAlarm = RecorderAlarm.instance
    @EnvironmentObject var vm: VoiceAlarmHomeViewModel
    var isDay:Bool
    
    var body: some View {
        if(isDay){
            Text("저녁에 새로 만들어 보시던가요").padding()
            AlarmCardView(alarms: $vm.nightAlarms)
        }else{
            AlarmCardView(alarms: $vm.dayAlarms)
            Text("낮에 새로 만들어 보시던가요").padding()
        }
        Button(action: {
            recorderAlarm.isFiring = false
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("돌아가기")
        })
    }
}

//struct AfterAlarmScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        AfterAlarmScreen()
//    }
//}
