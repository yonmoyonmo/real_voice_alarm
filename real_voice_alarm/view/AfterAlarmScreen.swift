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
    let notificationManager = NotificationManager.instance
    @EnvironmentObject var vm: VoiceAlarmHomeViewModel
    var isDay:Bool
    let currentAlarm:AlarmEntity
    
    var cardType:String = UserDefaults.standard.string(forKey: "cardType")!
    var themeType:String = UserDefaults.standard.string(forKey: "themeType")!
    
    var body: some View {
        GeometryReader { geometry in
            Group{
                VStack(alignment: .center){
                    Text("오늘 하루, \n 너무 고생 많았어요 :)").font(.system(size: 25, weight: .bold)).foregroundColor(Color.white)
                        .frame(width: CGFloat(geometry.size.width * 0.85), height: CGFloat(geometry.size.height * 0.2), alignment: .center).padding()
                    if(isDay){
                        VStack{
                            Text("오늘 저녁의 나에게 해주고 싶은 말을 지금 녹음해봐요!")
                                .font(.system(size: 21, weight: .bold)).padding()
                                .frame(width: CGFloat(geometry.size.width * 0.8), alignment: .center)
                                .background(Rectangle().fill(Color.white).opacity(0.4).shadow(radius: 5, x:0, y:5))
                                .cornerRadius(20)
                            
                            AlarmCardView(alarms: $vm.nightAlarms, isDay: false, cardType: cardType, themeType:self.themeType)
                        }
                    }else{
                        VStack{
                            AlarmCardView(alarms: $vm.dayAlarms, isDay: true, cardType: cardType, themeType:self.themeType)
                            Text("내일 아침의 나에게 해주고 싶은 말을 지금 녹음해봐요!")
                                .font(.system(size: 21, weight: .bold)).padding()
                                .frame(width: CGFloat(geometry.size.width * 0.8), alignment: .center)
                                .background(Rectangle().fill(Color.white).opacity(0.4).shadow(radius: 5, x:0, y:5))
                                .cornerRadius(20)
                        }
                    }
                    
                    Button(action: {
                        recorderAlarm.isFiring = false
                        //1.0.4 schedule repeating alarms one by one at dismiss timing
                        if(currentAlarm.isRepeating){
                            var weekDayFireAtSet:[Date] = []
                            let components = Calendar.current.dateComponents([.hour, .minute, .year], from: currentAlarm.fireAt!)
                            let todayComps = Calendar.current.dateComponents([.weekday], from: Date())
                            print("+++++++++++++++++++ dismiss and schedule next ++++++++++++++++++++++")
                            print("+++++++++++++++++++ cancel all first ++++++++++++++++++++++")
                            let semaphore = DispatchSemaphore(value: 0)
                            notificationManager.cancelNotification(id: currentAlarm.uuid!,
                                                                   repeatingDays: currentAlarm.repeatingDays,
                                                                   semaphore: semaphore)
                            semaphore.wait()
                            
                            for repeatDay in currentAlarm.repeatingDays {
                                //set repeating weekdays of fireAt
                                if(repeatDay != todayComps.weekday!){
                                    weekDayFireAtSet.append(createDate(weekday: repeatDay,
                                                                       hour:components.hour!,
                                                                       minute:components.minute! ,
                                                                       year: components.year!,
                                                                       month: nil,
                                                                       day: nil
                                                                      ))
                                }
                            }
                            notificationManager.scheduleRepeatingAlarms(dates: weekDayFireAtSet,
                                                                        tagName: currentAlarm.tagName!,
                                                                        id: currentAlarm.uuid!,
                                                                        audioName: currentAlarm.audioName!)
                        }
                        print("+++++++++++++++++++ dismiss and schedule next done ++++++++++++++++++++++")
                        recorderAlarm.setLastingTimeOfNext()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "house.circle.fill").font(.system(size:50, weight: .bold)).foregroundColor(Color.white).padding()
                    }).frame(width: CGFloat(geometry.size.width * 0.8), height: CGFloat(geometry.size.height * 0.2), alignment: .center)
                }
            }
            .frame(width: CGFloat(geometry.size.width),height:CGFloat(geometry.size.height), alignment: .center)
            .background(Image(themeType)
                            .resizable()
                            .aspectRatio(geometry.size, contentMode: .fill)
                            .edgesIgnoringSafeArea(.all))
        }
    }
}
