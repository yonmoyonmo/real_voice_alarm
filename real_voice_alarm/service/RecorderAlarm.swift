//
//  RecorderAlarm.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import Foundation
import AVFoundation
import UserNotifications
import CoreData

class RecorderAlarm: ObservableObject {
    static let instance = RecorderAlarm() //singleton object
    
    let coreDataManager = CoreDataManager.instance
    let notificationManager = NotificationManager.instance
    
    @Published var firingAlarmId: String = ""
    @Published var isFiring: Bool = false
    @Published var hour: Int = 0
    @Published var minute: Int = 0
    @Published var day: Int = 0
    
    init(){
        print("recorder alarm instance is created")
    }
 
    func saveAlarm(tagName:String, fireAt: Date, audioName: String, audioURL: URL, volume: Double, repeatingDays: [RepeatDays]) {
        let id:UUID = UUID()
        
        let newAlarm = AlarmEntity(context: coreDataManager.context)
        newAlarm.uuid = id.uuidString
        
        newAlarm.tagName = tagName
        newAlarm.fireAt = fireAt
        newAlarm.isActive = true
        newAlarm.isDay = isDay(fireAt: fireAt)
        
        newAlarm.audioName = audioName
        newAlarm.audioURL = audioURL
        newAlarm.volume = volume
        
        let intRepeatingDays:[Int] = []
        newAlarm.repeatingDays = intRepeatingDays
        
        notificationManager.scheduleAlarm(tagName: tagName, fireAt: fireAt, audioName: audioName, id: id.uuidString)
        coreDataManager.save(savedAlarmName: tagName)
        print("alarm saved and sheduled")
    }
    
    func saveRepeatingAlarms(tagName:String, fireAtList: [Date], audioName: String, audioURL: URL, volume: Double, repeatingDays: [RepeatDays]){
        let id:UUID = UUID()
        
        let newAlarm = AlarmEntity(context: coreDataManager.context)
        newAlarm.uuid = id.uuidString
        
        newAlarm.tagName = tagName
        newAlarm.fireAt = fireAtList[0]
        newAlarm.isActive = true
        newAlarm.isDay = isDay(fireAt: fireAtList[0])
        
        newAlarm.audioName = audioName
        newAlarm.audioURL = audioURL
        newAlarm.volume = volume
        
        var intRepeatingDays:[Int] = []
        for repeatingDay in repeatingDays {
            intRepeatingDays.append(repeatingDay.intName)
        }
        
        newAlarm.repeatingDays = intRepeatingDays
        
        notificationManager.scheduleRepeatingAlarms(dates: fireAtList, tagName: tagName, id: id.uuidString, audioName: audioName)
        coreDataManager.save(savedAlarmName: tagName)
    }
    
    func updateAlarm(alarm: AlarmEntity, tagName:String, fireAt: Date, audioName: String, audioURL: URL, volume: Double, repeatingDays: [RepeatDays]){
        //한개만 업데이트
        alarm.tagName = tagName
        alarm.fireAt = fireAt
        alarm.audioName = audioName
        alarm.audioURL = audioURL
        alarm.volume = volume
        let intRepeatingDays:[Int] = []
        alarm.repeatingDays = intRepeatingDays
        alarm.isDay = isDay(fireAt: fireAt)
        
        print("\(tagName) is now updating...")
        coreDataManager.save(savedAlarmName: tagName)
        
        if(alarm.isActive){
            print("re-schedule updated alarm")
            notificationManager.cancelNotification(id: alarm.uuid!, repeatingDays: intRepeatingDays)
            notificationManager.scheduleAlarm(
                tagName: tagName,
                fireAt: fireAt,
                audioName: audioName,
                id: alarm.uuid!
            )
        }
        print("alarm updated and re-scheduled")
    }
    
    func updateRepeatingAlarms(alarm: AlarmEntity,tagName:String, fireAtList: [Date], audioName: String, audioURL: URL, volume: Double, repeatingDays: [RepeatDays]){
        alarm.tagName = tagName
        alarm.fireAt = fireAtList[0]
        alarm.isDay = isDay(fireAt: fireAtList[0])
        
        alarm.audioName = audioName
        alarm.audioURL = audioURL
        alarm.volume = volume
        var intRepeatingDays:[Int] = []
        for repeatingDay in repeatingDays {
            intRepeatingDays.append(repeatingDay.intName)
        }
        alarm.repeatingDays = intRepeatingDays
        
        print("\(tagName) is now updating...")
        coreDataManager.save(savedAlarmName: tagName)
        
        if(alarm.isActive){
            print("re-schedule updated alarms")
            notificationManager.cancelNotification(id: alarm.uuid!, repeatingDays: intRepeatingDays)
            notificationManager.scheduleRepeatingAlarms(
                dates: fireAtList,
                tagName: tagName,
                id: alarm.uuid!,
                audioName: audioName)
        }
        print("alarms updated and re-scheduled")
    }
    
    func deleteAlarm(id:String, repeatingDays:[Int]){
        //아이디로 알람데이터와 노티를 찾아 갈 수 있음
        //알람 삭제하고, 스케쥴 된 노티 삭제
        coreDataManager.deleteTargetEntity(id: id)
        notificationManager.cancelNotification(id: id, repeatingDays: repeatingDays)
    }
    
    func alarmActiveSwitch(alarm:AlarmEntity){
        if(alarm.isActive){
            //turn it false
            alarm.isActive = false
            coreDataManager.save(savedAlarmName: alarm.tagName!)
        }else{
            //turn it true
            alarm.isActive = true
            coreDataManager.save(savedAlarmName: alarm.tagName!)
        }
    }
    
    func switchScheduledAlarms(isOn: Bool, alarm: AlarmEntity){
        if(isOn){
            //turn on
            if(alarm.repeatingDays != []){
                //repeatingDays가 있을 때
                var weekDayFireAtSet:[Date] = []
                let components = Calendar.current.dateComponents([.hour, .minute, .year], from: alarm.fireAt!)
                for repeatDay in alarm.repeatingDays {
                    weekDayFireAtSet.append(createDate(weekday: repeatDay,
                                                       hour:components.hour!,
                                                       minute:components.minute! ,
                                                       year: components.year!))
                }
                notificationManager.scheduleRepeatingAlarms(dates: weekDayFireAtSet,
                                                            tagName: alarm.tagName!,
                                                            id: alarm.uuid!,
                                                            audioName: alarm.audioName!)
                //isActive = true
                alarmActiveSwitch(alarm: alarm)
                setLastingTimeOfNext()
            }else{
                //일회성일때
                notificationManager.scheduleAlarm(tagName: alarm.tagName!,
                                                  fireAt: alarm.fireAt!,
                                                  audioName: alarm.audioName!,
                                                  id: alarm.uuid!)
                //isActive = true
                alarmActiveSwitch(alarm: alarm)
                setLastingTimeOfNext()
            }
        }else{
            //turn off
            //그냥 모조리 스케쥴 빼버리긔
            notificationManager.cancelNotification(id: alarm.uuid!, repeatingDays: alarm.repeatingDays)
            //isActive = false
            alarmActiveSwitch(alarm: alarm)
            setLastingTimeOfNext()
        }
    }
    
    func checkCurrentDeliverdAlarmId(){
        let center = UNUserNotificationCenter.current()
        var firstDeliverdAlarmId:String = ""
        var newId = ""
        center.getDeliveredNotifications(completionHandler: { deliverdNotis in
            if deliverdNotis.isEmpty{
                print("empty deliverd")
            }else{
                //있다면 @를 뗀다
                firstDeliverdAlarmId = deliverdNotis[0].request.identifier
                
                if firstDeliverdAlarmId.contains("@"){
                    let deviderIndex:String.Index = firstDeliverdAlarmId.firstIndex(of: "@")!
                    newId = String(firstDeliverdAlarmId[...deviderIndex])
                    
                    if let i = newId.firstIndex(of: "@"){
                        newId.remove(at: i)
                    }
                }else{
                    newId = firstDeliverdAlarmId
                }
                print("[ remaining deliverd noti ]")
                print(newId)
                DispatchQueue.main.async{
                    self.isFiring = true
                    self.firingAlarmId = newId
                }
            }
        })
    }
    
    func removeDeliverdAlarms(){
        print("remove all delived alarms")
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
    
    func setLastingTimeOfNext(){
        print("====== debug set lasting time of next ======")
        let center = UNUserNotificationCenter.current()
        
        let now = Date()
        let nowDateComponents = Calendar.current.dateComponents([.weekday, .year, .hour ,.minute], from: now)
        
        var pendingAlarmsDates:[[AnyHashable:Any]] = []
        
        var target:[AnyHashable:Any] = [:]
        
        center.getPendingNotificationRequests(completionHandler: { requests in
            //setPendings
            for request in requests {
                pendingAlarmsDates.append(request.content.userInfo)
            }
            print(pendingAlarmsDates)
            //setTargets
            for pendingAlarmsDate in pendingAlarmsDates {
                let targetWeekday = (pendingAlarmsDate["weekday" as String] as? NSString)!.intValue
                let targetHour = (pendingAlarmsDate["hour" as String] as? NSString)!.intValue
                let targetMinute = (pendingAlarmsDate["minute" as String] as? NSString)!.intValue
                
                //find today's next
                if(targetWeekday == nowDateComponents.weekday!){
                    if(targetHour > nowDateComponents.hour!){
                        target = pendingAlarmsDate
                    }else if(targetHour == nowDateComponents.hour!){
                        if(targetMinute > nowDateComponents.minute!){
                            target = pendingAlarmsDate
                        }
                    }
                }
            }
            if(!target.isEmpty){
                print("today's next found!")
                print(target)
                let targetHour = (target["hour" as String] as? NSString)!.intValue
                var targetMinute = (target["minute" as String] as? NSString)!.intValue
                
                var nowMinute = nowDateComponents.minute!
                let nowHour = nowDateComponents.hour!
                
                var i = 0
                while(i < targetHour){
                    i += 1
                    targetMinute += 60
                }
                
                var j = 0
                while(j < nowHour){
                    j += 1
                    nowMinute += 60
                }
                print("now sex hour \(nowHour)")
                print("now sex minute \(nowMinute)")
                var realMinute = Int(targetMinute) - nowMinute
                print("before sex minute \(realMinute)")
                
                var realHour = 0
                if(realMinute >= 60){
                    realHour = realMinute / 60
                    print("before sex hour \(realHour)")
                    var i = 0
                    while(i<realHour){
                        i+=1
                        realMinute = realMinute - 60
                        
                    }
                }
                print("sex hour \(realHour)")
                print("sex minute \(realMinute)")
                DispatchQueue.main.async {
                    self.hour = realHour
                    self.minute = realMinute
                    self.day = 0
                }
                print("setLastingTimeOfNext done! sex")
                return
            }else{
                //there's no today's alarm
                //let's find closest nextDay shit
                var min = 8
                for pendingAlarmsDate in pendingAlarmsDates {
                    var targetWeekday = (pendingAlarmsDate["weekday" as String] as? NSString)!.intValue
                    //오늘과 가장 가까운 다음 날을 찾아야하는디...
                    //그것은 바로... 7과 오늘 사이라면 차이가 제일 작은 것 1과 오늘 사이라면 차이가 제일 큰것...
                    if(targetWeekday <= nowDateComponents.weekday!){
                        targetWeekday = targetWeekday + 7
                    }
                    let diff = Int(targetWeekday) - nowDateComponents.weekday!
                    if(diff < min){
                        min = diff
                    }
                }
                print("min : \(min)")
                if(min == 8){
                    min = 0
                }
                DispatchQueue.main.async {
                    self.day = min
                    self.minute = 0
                    self.hour = 0
                }
                print("setLastingTimeOfNext done!")
                return
            }
        })
    }
}

