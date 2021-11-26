//
//  AlarmCard.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/03.
//

import SwiftUI

//let cardWidth = 320.0
//let cardHeight = 213.34
//let cardRadius = 10.0
//let shadowX = 0.0
//let shadowY = 4.0
let cardWidth = CGFloat(UIScreen.screenWidth * 0.85)
let cardHeight = CGFloat(UIScreen.screenWidth * 0.55)
let cardRadius = CGFloat(15.0)
let shadowX = CGFloat(0.0)
let shadowY = CGFloat(4.0)

struct AlarmCardView: View {
    @Binding var alarms:[AlarmEntity]
    @EnvironmentObject var viewModel:VoiceAlarmHomeViewModel
    var isDay:Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(){
                ForEach($alarms){$alarm in
                    AlarmCard(alarm: $alarm, alarmToggle: alarm.isActive, isDay:isDay)
                }
                addNewCardCard(isDay: self.isDay)
            }.padding(.leading, 24)
                .padding(.bottom, 20)
        })
    }
}

struct AlarmCard: View {
    @Binding var alarm:AlarmEntity
    @EnvironmentObject var viewModel:VoiceAlarmHomeViewModel
    let recorderAlarm = RecorderAlarm.instance
    
    @State var alarmToggle:Bool
    @State var showEditAlarmModal:Bool = false
    @State var deleteAlert:Bool = false
    
    let repeatingDays = [1,2,3,4,5,6,7]
    
    var isDay:Bool
    
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
            ZStack{
                VStack(alignment: .center, spacing: 0) {
                    
                    HStack{
                        Spacer()
                        Button(
                            action: {
                            }, label: {
                                Toggle("", isOn: $alarmToggle).toggleStyle(SwitchToggleStyle(tint: .white.opacity(0.8)))
                                    .onChange(of: alarmToggle){ value in
                                    recorderAlarm.switchScheduledAlarms(isOn: value, alarm: alarm)
                                    }
                            }
                        ).frame(width: 60, height: 30, alignment: .center)
                        .sheet(isPresented: self.$showEditAlarmModal) {
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
                    }.padding(15)
                    
                    HStack{
                        VStack{
                            Text(alarm.fireAt!, style: .time)
                                .font(.system(size: 40, weight: .bold)).tracking(2).foregroundColor(.white)
                            Label{
                                Text(alarm.tagName!).font(.system(size: 20, weight: .bold)).tracking(2).foregroundColor(.white)
                            } icon:{
                                Image(systemName:"tag.fill").foregroundColor(.white)
                            }
                        }
                        //delete
                        Button(action: {
                            deleteAlert.toggle()
                        }, label: {
                            Image(systemName: "trash").font(.system(size: 25, weight: .bold)).foregroundColor(.white)
                        }).alert(isPresented: $deleteAlert) {
                            Alert(
                                title: Text("알람 삭제"),
                                message: Text("진짜로 알람을 삭제합니까?"),
                                primaryButton: .default(Text("진짜 삭제"), action: {
                                    recorderAlarm.deleteAlarm(id: alarm.uuid!, repeatingDays: alarm.repeatingDays)
                                    viewModel.getAlarms()
                                }), secondaryButton: .cancel(Text("가짜로입니다."))
                            )
                        }
                    }.padding(.leading).padding(.trailing)
                    
                    Spacer()
                    
                    
                    //반복
                    HStack(alignment: .center){
                        
                        ForEach(repeatingDays, id:\.self){ repeatDay in
                            Text(RepeatDays(rawValue: repeatDay)!.shortName)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(alarm.repeatingDays.contains(repeatDay) ? Color.mainBlue : Color.textBlack)
                        }
                        
                    }.frame(width: cardWidth, height: CGFloat(48.0)).background(Color.mainGrey.opacity(0.5))
                    
                    
                    
                }
                .background(isDay == true ?
                            Image("CardAD").resizable().scaledToFill()
                                .frame(width: cardWidth, height: cardHeight, alignment: .top).opacity(0.8)
                                
                            :
                                Image("CardAN").resizable().scaledToFill()
                                .frame(width: cardWidth, height: cardHeight, alignment: .top).opacity(0.8)
                            
                )
                .frame(width: cardWidth, height: cardHeight)
                .cornerRadius(cardRadius)
                .shadow(radius: cardRadius, x: shadowX, y: shadowY)
                .opacity(alarmToggle == true ? 1 : 0.4)
                .padding(.trailing, 5)
                
            }.frame(width: cardWidth, height: cardHeight).onTapGesture {
                self.showEditAlarmModal.toggle()
            }
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
                    self.showAddAlarmModal.toggle()
                }
            ){
                Image(systemName: "plus.circle.fill").frame(width:cardWidth, height: cardHeight, alignment: .center)
                    .foregroundColor(.black)
                    .font(.system(size: 65.0, weight: .bold))
            }
            .sheet(isPresented: self.$showAddAlarmModal) {
                AlarmSetting(isDay: self.isDay)
            }
        }
        .background(Color.lighterGrey.opacity(0.5))
        .frame(width: cardWidth, height: cardHeight)
        .cornerRadius(cardRadius)
        .shadow(radius: cardRadius, x: shadowX, y: shadowY)
        .padding(.trailing, 24)
    }
}

extension  Color {
    static let mainGrey = Color("mainGrey")
    static let mainBlue = Color("mainBlue")
    static let lighterGrey = Color("lighterGrey")
    static let textBlack = Color("TextBlack")
    static let myAccent = Color("MyAccent")
}
