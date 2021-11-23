//
//  AlarmSetting.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import SwiftUI

struct AlarmSetting: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var vm:VoiceAlarmHomeViewModel
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder()
    let audioPlayer: AudioPlayer = AudioPlayer.instance
    let recorderAlarm: RecorderAlarm = RecorderAlarm.instance
    let semaphore = DispatchSemaphore(value: 0)
    //-----------------------------------------
    @State var tagName: String = "태그 없음"
    @State var fireAt: Date = Date()
    @State var repeatDays: [RepeatDays] = []
    
    @State var audioName: String = "선택된 목소리 없음"
    @State var audioURL: URL?
    @State private var volume: Double = 10
    
    @State var audioData: [String:Any] = [:]
    @State var fileName: String = "제목 없음"
    //----------------------------------------
    @State var isShowingAlert: Bool = false
    @State var isPlayBack: Bool = false
    @State var isShowingTagNameEditAlert:Bool = false
    //-----------------------------------------
    
    var isDay:Bool
    
    var DaydateClosedRange: ClosedRange<Date> {
        
        var minComps = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: Date())
        minComps.hour = 0
        minComps.minute = 0
        
        var maxComps = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: Date())
        maxComps.hour = 11
        maxComps.minute = 59
        
        let myCalendar = Calendar(identifier: .gregorian)
        
        let min = myCalendar.date(from: minComps)!
        let max = myCalendar.date(from: maxComps)!
        
        return min...max
    }
    
    var NightdateClosedRange: ClosedRange<Date> {
        
        var minComps = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: Date())
        minComps.hour = 12
        minComps.minute = 0
        
        var maxComps = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: Date())
        maxComps.hour = 23
        maxComps.minute = 59
        
        let myCalendar = Calendar(identifier: .gregorian)
        
        let min = myCalendar.date(from: minComps)!
        let max = myCalendar.date(from: maxComps)!
        
        return min...max
    }
    
    func saveAlarm(){
        if(audioURL==nil){
            print("오디오 유알엘 없는 경우에 예외처리 하라")
            vm.getAlarms()
            self.presentationMode.wrappedValue.dismiss()
            return
        }
        //save alarm
        if(!repeatDays.isEmpty){
            var weekDayFireAtSet:[Date] = []
            let components = Calendar.current.dateComponents([.hour, .minute, .year], from: fireAt)
            for repeatDay in repeatDays {
                weekDayFireAtSet.append(createDate(weekday: repeatDay.intName,
                                                   hour:components.hour!,
                                                   minute:components.minute! ,
                                                   year: components.year!
                                                  ))
            }
            recorderAlarm.saveRepeatingAlarms(tagName: tagName,
                                              fireAtList: weekDayFireAtSet,
                                              audioName: audioName,
                                              audioURL: audioURL!,
                                              volume: volume,
                                              repeatingDays : repeatDays)
            vm.getAlarms()
            recorderAlarm.setLastingTimeOfNext()
            
            self.presentationMode.wrappedValue.dismiss()
        }else{
            recorderAlarm.saveAlarm(tagName: tagName,
                                    fireAt: fireAt,
                                    audioName: audioName,
                                    audioURL: audioURL!,
                                    volume: volume,
                                    repeatingDays : repeatDays
            )
            vm.getAlarms()
            recorderAlarm.setLastingTimeOfNext()
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    //예외처리 잔뜩 해야한다.
    //일단 이름짓는 것들 길이제한부터
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .center) {
                    HStack(){
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("취소").foregroundColor(.black).padding()
                        })
                        Spacer()
                        //완료 버튼 : 알람 데이터 저장 + 스케쥴링
                        Button(action: {
                            saveAlarm()
                        }, label:{
                            Text("완료").padding()
                        })
                    }
                    //데이트 피커
                    GroupBox{
                        if(isDay == true){
                            DatePicker("", selection: $fireAt, in: DaydateClosedRange, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                        }else{
                            DatePicker("", selection: $fireAt, in: NightdateClosedRange, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                        }
                    }.frame(width: (UIScreen.screenWidth)-40)
                    
                    //요일 반복
                    GroupBox(label: Label("요일반복", systemImage: "calendar")){
                        RepeatDaysSettingView(repeatDays: $repeatDays).padding(5)
                    }.frame(width: (UIScreen.screenWidth)-40)
                    
                    GroupBox{
                        HStack{
                            Label("태그", systemImage: "tag.fill")
                            Spacer()
                            Text("\(tagName)").onTapGesture {
                                isShowingTagNameEditAlert.toggle()
                            }
                        }
                    }.frame(width: (UIScreen.screenWidth)-40)
                    
                    GroupBox{
                        HStack{
                            Image(systemName: "speaker.wave.3.fill")
                            //volume slider
                            Slider(value: $volume, in: 0...20, step: 0.1)
                        }
                        Divider()
                        HStack{
                            Text("현재 목소리 : \(audioName)").foregroundColor(.black)
                            Spacer()
                            NavigationLink(destination: RecordingsList(
                                audioRecorder: audioRecorder,
                                audioName:$audioName,
                                audioURL:$audioURL)
                            ){
                                Text("목소리 고르기").bold()
                            }
                        }
                        
                    }.frame(width: (UIScreen.screenWidth)-40).padding(.horizontal)
                    
                    

                    //@@@@@@@@@<< recorder  >>@@@@@@@@@@@@@@//
                    if(audioRecorder.recording == true){
                        Image("recording").frame(width: (UIScreen.screenWidth)-40)
                    }else{
                        Image("notRecording").frame(width: (UIScreen.screenWidth)-40)
                    }
                    if audioRecorder.recording == false {
                        Button(action: {
                            audioRecorder.startRecording(title: "\(fileName)")
                        }) {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                        }.padding()
                        
                    }else{
                        Button(action: {
                            audioData = audioRecorder.stopRecording()
                            audioName = audioData["audioName"] as! String
                            audioURL = audioData["audioURL"] as? URL
                            isPlayBack.toggle()
                        }) {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                        }.padding()
                    }
                    Text("\(audioName)")
                    Spacer()
                }//vStackend
            }//scroll view end
            .tagNameAlert(isShowing: $isShowingTagNameEditAlert, text: $tagName, title:"알람의 태그를 입력하세요")
            .playBackAlert(isShowing: $isPlayBack,
                           audioPlayer: self.audioPlayer,
                           audioURL: $audioURL,
                           audioName:$audioName)
            .navigationBarHidden(true)
        }//navi view end
    }
}

struct AlarmSetting_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSetting(isDay: false)
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

//struct MyGroupBoxStyle: GroupBoxStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.content
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray))
//            .overlay(configuration.label.padding(.leading, 4), alignment: .topLeading)
//    }
//}
