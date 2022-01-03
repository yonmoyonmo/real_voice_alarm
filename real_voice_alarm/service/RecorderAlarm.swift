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
    @Published var repeatingAlarmId: String = ""
    @Published var isFiring: Bool = false
    
    @Published var hour: Int = 0
    @Published var minute: Int = 0
    @Published var day: Int = 0
    
    init(){
        print("recorder alarm instance is created")
    }
 
    func saveAlarm(tagName:String, fireAt: Date, audioName: String, audioURL: URL, volume: Double, repeatingDays: [RepeatDays]) {
        let id:UUID = UUID()
        
        print("20211220 debug 06 fire at check before make entity: \(fireAt)")
        let debugComps = Calendar.current.dateComponents([.year ,.month, .day, .hour, .minute, .weekday], from: fireAt)
        print("20211220 debug 06 fireComps at check before make entity: \(debugComps)")
        
        let newAlarm = AlarmEntity(context: coreDataManager.context)
        newAlarm.uuid = id.uuidString
        
        newAlarm.tagName = tagName
        newAlarm.fireAt = fireAt
        newAlarm.isActive = true
        newAlarm.isDay = isDay(fireAt: fireAt)
        
        newAlarm.audioName = audioName
        newAlarm.audioURL = audioURL
        newAlarm.volume = volume
        newAlarm.isRepeating = false
        
        let intRepeatingDays:[Int] = []
        newAlarm.repeatingDays = intRepeatingDays
        
        notificationManager.scheduleAlarm(tagName: tagName, fireAt: fireAt, audioName: audioName, id: id.uuidString)
        coreDataManager.save(savedAlarmName: tagName)
        print("------------------------- alarm saved and sheduled -------------------------")
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
        newAlarm.isRepeating = true
        
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
        alarm.isRepeating = false
        
        print("------------------------- \(tagName) is now updating... -------------------------")
        coreDataManager.save(savedAlarmName: tagName)
        
        if(alarm.isActive){
            print("------------------------- re-schedule updated alarm -------------------------")
            let semaphore = DispatchSemaphore(value: 0)
            notificationManager.cancelNotification(id: alarm.uuid!, repeatingDays: intRepeatingDays, semaphore: semaphore)
            semaphore.wait()
            
//            debugPendingAlarms(semaphore:semaphore)
//            semaphore.wait()
            
            print("next line of semaphore wait")
            notificationManager.scheduleAlarm(
                tagName: tagName,
                fireAt: fireAt,
                audioName: audioName,
                id: alarm.uuid!
            )
            
//            debugPendingAlarms(semaphore:semaphore)
//            semaphore.wait()
            print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxß")
        }
        print("------------------------- alarm updated and re-scheduled -------------------------")
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
        alarm.isRepeating = true
        
        print("------------------------- \(tagName) is now updating... -------------------------")
        coreDataManager.save(savedAlarmName: tagName)
        
        if(alarm.isActive){
            print("------------------------- re-schedule updated alarms -------------------------")
            let semaphore = DispatchSemaphore(value: 0)
            notificationManager.cancelNotification(id: alarm.uuid!, repeatingDays: intRepeatingDays ,semaphore: semaphore)
            semaphore.wait()
            
//            debugPendingAlarms(semaphore:semaphore)
//            semaphore.wait()
            
            notificationManager.scheduleRepeatingAlarms(
                dates: fireAtList,
                tagName: tagName,
                id: alarm.uuid!,
                audioName: audioName)
            
//            debugPendingAlarms(semaphore:semaphore)
//            semaphore.wait()
            
            print("xxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxß")
        }
        print("------------------------- alarms updated and re-scheduled -------------------------")
    }
    
    func deleteAlarm(id:String, repeatingDays:[Int]){
        //아이디로 알람데이터와 노티를 찾아 갈 수 있음
        //알람 삭제하고, 스케쥴 된 노티 삭제
        print("------------------------- deleteAlarm called -------------------------")
        coreDataManager.deleteTargetEntity(id: id)
        
        let semaphore = DispatchSemaphore(value: 0)
        notificationManager.cancelNotification(id: id, repeatingDays: repeatingDays, semaphore: semaphore)
        semaphore.wait()
        print("\(id) is deleted")
    }
    
    func alarmActiveSwitch(alarm:AlarmEntity){
        print("------------------------- alarmActiveSwitch called -------------------------")
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
        print("------------------------- switchScheduledAlarms called -------------------------")
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
            let semaphore = DispatchSemaphore(value: 0)
            notificationManager.cancelNotification(id: alarm.uuid!, repeatingDays: alarm.repeatingDays, semaphore: semaphore)
            semaphore.wait()
            //isActive = false
            alarmActiveSwitch(alarm: alarm)
            setLastingTimeOfNext()
        }
    }
    
    func checkCurrentDeliverdAlarmId(){
        print("------------------------- checkCurrentDeliverdAlarmId called -------------------------")
        let semaphore = DispatchSemaphore(value: 0)
        debugPendingAlarms(semaphore: semaphore)
        semaphore.wait()
        
        let center = UNUserNotificationCenter.current()
        var firstDeliverdAlarmId:String = ""
        var newId = ""
        center.getDeliveredNotifications(completionHandler: { deliverdNotis in
            if deliverdNotis.isEmpty{
                print("there's no deliverd noti")
            }else{
                //있다면 @를 뗀다
                firstDeliverdAlarmId = deliverdNotis[0].request.identifier
                
                if(firstDeliverdAlarmId.contains("#")){
                    let deviderIndex:String.Index = firstDeliverdAlarmId.firstIndex(of: "#")!
                    firstDeliverdAlarmId = String(firstDeliverdAlarmId[...deviderIndex])
                    if let i = firstDeliverdAlarmId.firstIndex(of: "#"){
                        firstDeliverdAlarmId.remove(at: i)
                    }
                }
                
                if firstDeliverdAlarmId.contains("@"){
                    let deviderIndex:String.Index = firstDeliverdAlarmId.firstIndex(of: "@")!
                    newId = String(firstDeliverdAlarmId[...deviderIndex])
                    
                    if let i = newId.firstIndex(of: "@"){
                        newId.remove(at: i)
                    }
                }else{
                    newId = firstDeliverdAlarmId
                }
                print("[ remaining deliverd noti : \(newId)]")
                DispatchQueue.main.async{
                    self.isFiring = true
                    self.firingAlarmId = newId
                }
            }
        })
    }
    
    func removeDeliverdAlarms(){
        print("------------------------- removeDeliverdAlarms called -------------------------")
        
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
    
    func setLastingTimeOfNext(){
        let center = UNUserNotificationCenter.current()
        
        let now = Date()
        let nowDateComponents = Calendar.current.dateComponents([.weekday, .year, .hour ,.minute], from: now)
        
        var pendingAlarmsDates:[[AnyHashable:Any]] = []
        
        var target:[AnyHashable:Any] = [:]
        
        center.getPendingNotificationRequests(completionHandler: { requests in
            //setPendings
            for request in requests {
                if(!request.content.userInfo.isEmpty){
                    pendingAlarmsDates.append(request.content.userInfo)
                }
            }
            //find today's fastest alarm
            var minTargetHour = 25
            var minTargetMinute = 61
            for pendingAlarmsDate in pendingAlarmsDates {
                let targetWeekday = (pendingAlarmsDate["weekday" as String] as? NSString)!.intValue
                let targetHour = (pendingAlarmsDate["hour" as String] as? NSString)!.intValue
                let targetMinute = (pendingAlarmsDate["minute" as String] as? NSString)!.intValue
                
                if(targetWeekday == nowDateComponents.weekday!){
                    print("debug today's alarms : \(targetHour)")
                    if(targetHour > nowDateComponents.hour!){
                        if(minTargetHour > targetHour){
                            minTargetHour = Int(targetHour)
                            print("debug minTargetHour : \(minTargetHour)")
                            target = pendingAlarmsDate
                        }else if(minTargetHour == targetHour){
                            if(minTargetMinute > targetMinute){
                                minTargetHour = Int(targetHour)
                                minTargetMinute = Int(targetMinute)
                                target = pendingAlarmsDate
                            }
                        }
                    }
                }
            }
            //there's today's alarm
            if(!target.isEmpty){
                print("debug today's target : \(target)")
                let targetHour = (target["hour" as String] as? NSString)!.intValue
                var targetMinute = (target["minute" as String] as? NSString)!.intValue
                var nowMinute = nowDateComponents.minute!
                let nowHour = nowDateComponents.hour!
                
                print("same weekday ====> pending::=> \(targetHour):\(targetMinute) VS NOW::=>\(nowHour):\(nowMinute)")
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
                
                var realMinute = Int(targetMinute) - nowMinute
                
                
                var realHour = 0
                if(realMinute >= 60){
                    realHour = realMinute / 60
                    
                    var i = 0
                    while(i<realHour){
                        i+=1
                        realMinute = realMinute - 60
                        
                    }
                }
                
                DispatchQueue.main.async {
                    self.hour = realHour
                    self.minute = realMinute
                    self.day = 0
                }
                print("setLastingTimeOfNext done!")
                return
            }else{
                //there's no today's alarm
                //let's find closest nextDay shit
                var min = 8
                var hourDiffmin = 48
                
                var minTargetHours = 0
                var minTargetMinutes = 0
                
                for pendingAlarmsDate in pendingAlarmsDates {
                    var targetWeekday = (pendingAlarmsDate["weekday" as String] as? NSString)!.intValue
                    let targetHours = Int((pendingAlarmsDate["hour" as String] as? NSString)!.intValue)
                    let targetMinutes = Int((pendingAlarmsDate["minute" as String] as? NSString)!.intValue)
                    
                    //print("20211220 debug minTargetHour check 01 : hours : \(targetHours) || mimutes : \(targetMinutes)")
                    
                    //오늘과 가장 가까운 다음 날을 찾아야하는디...
                    if(targetWeekday <= nowDateComponents.weekday!){
                        targetWeekday = targetWeekday + 7
                    }
                    //weekday를 비교해서 오늘과 가장 가까운 weekday 찾는다.
                    let diff = Int(targetWeekday) - nowDateComponents.weekday!
                    //hour minute 비교해서 지금과 가장 가까운 hour minute 찾는다
                    //타겟 + 24 - 지금 이 가장 작은 것
                    var hourDiff = 0
                    var nowDateCompsHour = nowDateComponents.hour!
                    if(nowDateCompsHour == 0){
                        nowDateCompsHour = 24
                    }
                    if(nowDateCompsHour <= targetHours){
                        hourDiff = targetHours - nowDateCompsHour
                    }else{
                        hourDiff = (targetHours + 24) - nowDateCompsHour
                    }
                    if(diff < min){
                        min = diff
                    }
                    if(hourDiff < hourDiffmin){
                        hourDiffmin = hourDiff
                        minTargetHours = targetHours
                        minTargetMinutes = targetMinutes
                        print("2021 12 20 debugging minimum target 01 : \(targetHours) \(targetMinutes) || hourdiffmin : \(hourDiffmin)")
                    }else if(hourDiff == hourDiffmin && targetMinutes > nowDateComponents.minute!){
                        hourDiffmin = hourDiff
                        minTargetHours = targetHours
                        minTargetMinutes = targetMinutes
                        print("2021 12 20 debugging minimum target 01 : \(targetHours) \(targetMinutes) || hourdiffmin : \(hourDiffmin)")
                    }
                }
                if(min == 8){
                    min = 0
                }
                if(min == 1){
                    //24시간 이내로 차이나는 하루이틀 사이는 시간으로 표시하기 위한 계산
                    print("1 day diffenrence")
                    var nowMinute = nowDateComponents.minute!
                    var nowHour = nowDateComponents.hour!
                    if(nowHour == 0){
                        nowHour = 24
                    }
                    //하루 차이 나는 것을 편히 계산 하기 전에 24시간 서비스로 추가해드렸습니다.
                    minTargetHours += 24
                  
                    //print("20211220 debug 04: hours : \(minTargetHours) || mimutes : \(minTargetMinutes)")
                    print("tomorrow's ====> pending::=> \(minTargetHours):\(minTargetMinutes) VS NOW::=>\(nowHour):\(nowMinute)")
                    
                    var i = 0
                    while(i < minTargetHours){
                        i += 1
                        minTargetMinutes += 60
                    }
                    
                    var j = 0
                    while(j < nowHour){
                        j += 1
                        nowMinute += 60
                    }
                    
                    var realMinute = Int(minTargetMinutes) - nowMinute
                    
                    var realHour = 0
                    if(realMinute >= 60){
                        realHour = realMinute / 60
                        
                        var i = 0
                        while(i<realHour){
                            i+=1
                            realMinute = realMinute - 60
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.hour = realHour
                        self.minute = realMinute
                        self.day = 0
                    }
                    print("setLastingTimeOfNext done!")
                    return
                }else{
                    DispatchQueue.main.async {
                        self.day = min
                        self.minute = 0
                        self.hour = 0
                    }
                    return
                }
            }
        })
    }
 
    func cancelRingingPendingAlarms(){
        print("------------------------- cancelRingingPendingAlarms called -------------------------")
        
        if(self.repeatingAlarmId == ""){
            //노 반복 알람의 경우 고냥 아이디를 넘긴다.
            notificationManager.cancelRingNotis(id: firingAlarmId)
        }else{
            notificationManager.cancelRingNotis(id: repeatingAlarmId)
        }
    }
    
    func debugPendingAlarms(semaphore: DispatchSemaphore){
        print("------------------------- debugPendingAlarms called -------------------------")
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print("\(request.identifier)")
            }
            semaphore.signal()
        })
    }
    
    func snoozeAlarm(alarm:AlarmEntity, snoozeMimutes:Int){
        let id = alarm.uuid!
        let todayNow = Date()
        let tagName = alarm.tagName!
        let audioName = alarm.audioName!
        let fireAt = Calendar.current.date(byAdding: .minute, value: snoozeMimutes, to: todayNow)!
        notificationManager.scheduleAlarm(tagName: tagName, fireAt: fireAt, audioName:audioName , id: id)
    }
}


