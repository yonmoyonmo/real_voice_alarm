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
                    AlarmCard(alarm: alarm, viewModel: viewModel, alarmToggle: alarm.isActive)
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
    
    @State var alarmToggle:Bool
    
    @State var showEditAlarmModal:Bool = false
    
    var body: some View{
        VStack(alignment: .center) {
            HStack{
                Toggle("", isOn: $alarmToggle).onChange(of: alarmToggle){ value in
                    print("toggled the alarm switch \(value)")
                    recorderAlarm.switchScheduledAlarms(isOn: value, alarm: alarm)
                }.toggleStyle(SwitchToggleStyle(tint: .black)).padding(5)
            }
            HStack{
                VStack{
                    Text(alarm.tagName!)
                    Text(alarm.fireAt!, style: .time)
                        .font(.largeTitle)
                }
                Menu{
                    Button(action: {
                        recorderAlarm.deleteAlarm(id: alarm.uuid!, repeatingDays: alarm.repeatingDays)
                        viewModel.getAlarms()
                    }, label: {
                        Text("알람 삭제")
                    })
                    Button(action: {
                        print("alarm setting modal")
                        self.showEditAlarmModal = true
                    }, label: {
                        Text("알람 편집")
                    }).sheet(isPresented: self.$showEditAlarmModal) {
                        AlarmEdit(alarm: alarm, vm: viewModel)
                    }
                } label:{
                    Image(systemName: "pencil").font(.system(.largeTitle)).foregroundColor(.black)
                }
            }
            if (!alarm.repeatingDays.isEmpty){
                HStack{
                    ForEach(alarm.repeatingDays, id: \.self){ repeatDay in
                        Text(RepeatDays(rawValue: repeatDay)!.shortName)
                    }
                }
            }else{
                Text("반복 없음")
            }
        }
        .frame(width: 250, height: 180, alignment: .top)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 4))
        .padding()
    }
}

struct addNewCardCard: View{
    @State private var showAddAlarmModal = false
    var viewModel:VoiceAlarmHomeViewModel
    
    var body: some View{
        VStack(alignment: .center) {
            Button(action: {
                print("alarm setting modal")
                self.showAddAlarmModal = true
            }){
                Image(systemName: "plus.circle.fill").frame(width:250, height: 180, alignment: .center)
                    .foregroundColor(.black)
                    .font(.system(size: 56.0, weight: .bold))
            }.sheet(isPresented: self.$showAddAlarmModal) {
                AlarmSetting(vm:viewModel)
            }
        }
        .frame(width: 250, height: 180, alignment: .top)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 4))
        .padding()
    }
}

struct AlarmCard_Previews: PreviewProvider {
    static var previews: some View {
        let alarms:[AlarmEntity] = []
        AlarmCardView(alarms: alarms, viewModel: VoiceAlarmHomeViewModel())
    }
}
