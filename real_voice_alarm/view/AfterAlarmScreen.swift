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
        GeometryReader { geometry in
            Group{
                VStack(alignment: .center){
                    Text("오늘 하루, \n 너무 고생 많았어요 :)").font(.system(size: 25, weight: .bold)).foregroundColor(Color.white)
                    if(isDay){
                        VStack{
                            Text("오늘 저녁의 나에게 해주고 싶은 말을 지금 녹음해봐요!")
                                .font(.system(size: 21, weight: .bold)).padding()
                                .frame(width: CGFloat(geometry.size.width * 0.8), alignment: .center)
                                .background(Rectangle().fill(Color.white).opacity(0.4).shadow(radius: 5, x:0, y:5))
                                .cornerRadius(20)
                            
                            AlarmCardView(alarms: $vm.nightAlarms, isDay: false)
                            
                        }
                    }else{
                        VStack{
                            AlarmCardView(alarms: $vm.dayAlarms, isDay: true)
                            
                            Text("내일 아침의 나에게 해주고 싶은 말을 지금 녹음해봐요!")
                                .font(.system(size: 21, weight: .bold)).padding()
                                .frame(width: CGFloat(geometry.size.width * 0.8), alignment: .center)
                                .background(Rectangle().fill(Color.white).opacity(0.4).shadow(radius: 5, x:0, y:5))
                                .cornerRadius(20)
                            
                        }
                    }
                    Button(action: {
                        recorderAlarm.isFiring = false
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "house.circle.fill").font(.system(size:50, weight: .bold)).foregroundColor(Color.white).padding()
                    })
                }
            }
            .frame(width: CGFloat(geometry.size.width),height:CGFloat(geometry.size.height), alignment: .center)
            .background(Image("Filter40A")
                            .resizable()
                            .aspectRatio(geometry.size, contentMode: .fill)
                            .edgesIgnoringSafeArea(.all))
            
            
        }
    }
}
