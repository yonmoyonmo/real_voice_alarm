//
//  AlarmCard.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/03.
//

import SwiftUI

struct AlarmCardView: View {
    var alarms:[AlarmEntity]
    var viewModel:VoiceAlarmHomeViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(){
                ForEach(alarms){alarm in
                    AlarmCard(alarm: alarm, viewModel: viewModel)
                }
                addNewCardCard(viewModel:viewModel)
            }
        })
    }
}

struct AlarmCard: View {
    var alarm:AlarmEntity
    var viewModel:VoiceAlarmHomeViewModel
    let recorderAlarm = RecorderAlarm.instance
    
    @State private var alarmToggle = true
    
    var body: some View{
        VStack(alignment: .center) {
            HStack{
                Toggle("", isOn: $alarmToggle).toggleStyle(SwitchToggleStyle(tint: .black)).padding(5)
            }
            HStack{
                VStack{
                    Text(alarm.tagName!)
                    Text(alarm.fireAt!, style: .time)
                        .font(.largeTitle)
                }
                Menu{
                    Button(action: {
                        recorderAlarm.deleteAlarm(id: alarm.uuid!)
                        viewModel.getAlarms()
                    }, label: {
                        Text("알람 삭제")
                    })
                } label:{
                    Image(systemName: "list.dash").font(.system(size: 20.0, weight: .bold))
                }
            }
            HStack{
                Text("월화수목금토일드가는곳")
            }
        }
        .frame(width: 250, height: 180, alignment: .top)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 4))
        .padding()
    }
}

struct addNewCardCard: View{
    @State private var showModal = false
    var viewModel:VoiceAlarmHomeViewModel
    
    var body: some View{
        VStack(alignment: .center) {
            Button(action: {
                print("alarm setting modal")
                self.showModal = true
            }){
                Image(systemName: "plus.circle.fill").frame(width:250, height: 180, alignment: .center)
                    .font(.system(size: 56.0, weight: .bold))
            }.sheet(isPresented: self.$showModal) {
                AlarmSetting(vm:viewModel)
            }
        }
        .frame(width: 250, height: 180, alignment: .top)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 4))
        .padding()
    }
}

struct AlarmCard_Previews: PreviewProvider {
    static var previews: some View {
        let alarms:[AlarmEntity] = []
        AlarmCardView(alarms: alarms, viewModel: VoiceAlarmHomeViewModel())
    }
}
