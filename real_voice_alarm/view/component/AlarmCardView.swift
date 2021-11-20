//
//  AlarmCard.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/03.
//

import SwiftUI

struct AlarmCardView: View {
    @Binding var alarms:[AlarmEntity]
    @EnvironmentObject var viewModel:VoiceAlarmHomeViewModel
    var isDay:Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(){
                ForEach($alarms){$alarm in
                    AlarmCard(alarm: $alarm, alarmToggle: alarm.isActive)
                }
                addNewCardCard(isDay: self.isDay)
            }
        })
    }
}

struct AlarmCard: View {
    @Binding var alarm:AlarmEntity
    @EnvironmentObject var viewModel:VoiceAlarmHomeViewModel
    let recorderAlarm = RecorderAlarm.instance
    
    @State var alarmToggle:Bool
    
    @State var showEditAlarmModal:Bool = false
    
    func intRepeatingDaysToEnumSet(repeatingDays: [Int]) ->[RepeatDays] {
        var result:[RepeatDays] = []
        let intRepetingDays = self.alarm.repeatingDays
        for intRepetingDay in intRepetingDays {
            result.append(RepeatDays(rawValue: intRepetingDay)!)
        }
        return result
    }
    
    var body: some View{
        if(alarm.tagName != nil){
            
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
                            print("AlarmCardView's getAalrms")
                            viewModel.getAlarms()
                        }, label: {
                            Text("알람 삭제")
                        })
                    } label:{
                        Image(systemName: "pencil").font(.system(.largeTitle)).foregroundColor(.black)
                    }
                }
                //edit alarm
                Button(action: {
                    self.showEditAlarmModal.toggle()
                }, label: {
                    Text("알람 편집")
                }).sheet(isPresented: self.$showEditAlarmModal) {
                    AlarmEdit(
                        alarm: self.alarm,
                        tagNameEditted: self.alarm.tagName!,
                        fireAtEditted: self.alarm.fireAt!,
                        repeatDaysEditted: intRepeatingDaysToEnumSet(repeatingDays: self.alarm.repeatingDays),
                        audioNameEditted: self.alarm.audioName!,
                        audioURLEditted: self.alarm.audioURL!,
                        volumeEditted: self.alarm.volume
                    )
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
}

struct addNewCardCard: View{
    @State private var showAddAlarmModal = false
    @EnvironmentObject var viewModel:VoiceAlarmHomeViewModel
    var isDay:Bool

    var body: some View{
        VStack(alignment: .center) {
            Button(
                action: {
                    print("alarm setting modal")
                    self.showAddAlarmModal.toggle()
                }
            ){
                Image(systemName: "plus.circle.fill").frame(width:250, height: 180, alignment: .center)
                    .foregroundColor(.black)
                    .font(.system(size: 56.0, weight: .bold))
            }
            .sheet(isPresented: self.$showAddAlarmModal) {
                AlarmSetting(isDay: self.isDay)
            }
        }
        .frame(width: 250, height: 180, alignment: .top)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 4))
        .padding()
    }
}

