//
//  NotificationManager.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationManager{
    static let instance = NotificationManager()
    
    init(){
        print("Notification Manager is created")
    }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Error in requestAuthorization \(error)")
            }else{
                print("requestAuthorization success")
            }
        }
    }
    
    func scheduleAlarm(tagName:String, fireAt: Date, audioName: String, id: String, isNonRepeatingUpdate:Bool) {
        print("=================== scheduleAlarm called ===================")
        print("debug sample audio name : \(audioName)")
        print("===== main alarm id \(id) =====")
        print("2022 05 15 debug is it a non-repeat update ? : \(isNonRepeatingUpdate) ")
        let now = Date()
        let nowDateComponents = Calendar.current.dateComponents([.year,.month,.day, .hour, .minute, .weekday, .second], from: now)
        
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day, .hour, .minute, .weekday, .second], from: fireAt)
        dateComponents.second = 0
        if(isNonRepeatingUpdate){
            dateComponents.weekday = nowDateComponents.weekday!
        }
        
        print("#############################################")
        print("20211220 debug 01 input : \(dateComponents)")
        print("20211220 debug 02 now : \(nowDateComponents)")
        var nowDateCompsHour = nowDateComponents.hour!
        
        //00시의 경우 24시로 비교한다.
        if(nowDateCompsHour == 0){
            nowDateCompsHour = 24
        }
        
        //지금보다 이전시간에 설정한다면 내일로 넘긴다
        if(dateComponents.hour! <= nowDateCompsHour  && dateComponents.minute! <= nowDateComponents.minute!){
            print("지금보다 과거라면 내일로...")
            if(nowDateComponents.weekday! < 7){ // 일 월 화 수 목 금 1..6
                print("일 월 화 수 목 금...의 경우")
                dateComponents.weekday = nowDateComponents.weekday! + 1
            }else if(nowDateComponents.weekday! == 7){
                //토요일이면 일요일로 넘겨야하기 때문에 1로 돌려보린다.
                print("토...의 경우")
                dateComponents.weekday = 1
            }
        }
        print("20211220 debug 2.5: now : \(nowDateComponents) || after edit input \(dateComponents)")
        print("#############################################")
        let content = UNMutableNotificationContent()
        content.title = "Motivoice is arrived"
        content.subtitle = "\(tagName)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: audioName))
        content.userInfo = [
            "year" : "\(dateComponents.year!)",
            "weekday": "\(dateComponents.weekday!)",
            "hour":"\(dateComponents.hour!)",
            "minute":"\(dateComponents.minute!)"
        ]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("schedule alarm error : \(error)")
            }
        }
        
        //debug
        print("debug : \(id) => \(dateComponents) => scheduled successfully")
        print("===== main alarm is scheduled =====")
        
        //let's make this alarm ringing!
        var ringingDateComponent  = dateComponents
        var intervalSecond = 0
        
        for i in 0..<5{
            intervalSecond += 11
            
            ringingDateComponent.second! = intervalSecond
            let ringingId = "\(id)#\(intervalSecond)"
            
            let ringingContent = UNMutableNotificationContent()
            ringingContent.title = "Motivoice is arrived"
            ringingContent.subtitle = "\(tagName)"
            ringingContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: audioName))
            ringingContent.userInfo = [:]
            
            let rigingTrigger = UNCalendarNotificationTrigger(dateMatching: ringingDateComponent, repeats: true)
            
            let ringingRequest = UNNotificationRequest(identifier: ringingId, content: ringingContent, trigger: rigingTrigger)
            
            UNUserNotificationCenter.current().add(ringingRequest) {(error) in
                if let error = error {
                    print("schedule alarm error : \(error)")
                }
            }
            print("\(i) : debug ringing: \(ringingId) => \(ringingDateComponent) => scheduled successfully")
        }
        print("===== main alarm's ringing pendings are scheduled =====")
    }
    
    //리피팅 알람 세팅
    func scheduleRepeatingAlarms(dates: [Date],tagName:String, id:String, audioName:String) {
        print("=================== scheduleRepeatingAlarms called ===================")
        print("===== main alarm id \(id) =====")
        
        var componentsToSaveList:[DateComponents] = []
        let content = UNMutableNotificationContent()
        
        for date in dates {
            componentsToSaveList.append(Calendar.current.dateComponents([.weekday,.hour,.minute,.second, .year], from: date))
        }
        var j = 1
        for var componentsToSave in componentsToSaveList {
            let repeatingId = RepeatDays(rawValue: componentsToSave.weekday!)?.fullName
            let devider:String = "@"
            let newId = id + devider + repeatingId!
            componentsToSave.second = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: componentsToSave, repeats: true)
            
            content.title = "Motivoice is arrived"
            content.body = "\(tagName)"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: audioName))
            content.userInfo = [
                "year" : "\(componentsToSave.year!)",
                "weekday": "\(componentsToSave.weekday!)",
                "hour":"\(componentsToSave.hour!)",
                "minute":"\(componentsToSave.minute!)"
            ]
            
            let request = UNNotificationRequest(identifier: newId, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {(error) in
                if let error = error {
                    print("scheduleRepeatingAlarms error: \(error)")
                }
            }
            
            print("[ \(j) ] :===== main alarm is scheduled =====")
            j += 1
            
            var ringingDateComponent  = componentsToSave
            var intervalSecond = 0
            
            for i in 0..<5{
                intervalSecond += 11
                
                ringingDateComponent.second! = intervalSecond
                let ringingId = "\(newId)#\(intervalSecond)"
                
                let ringingContent = UNMutableNotificationContent()
                ringingContent.title = "Motivoice is arrived"
                ringingContent.subtitle = "\(tagName)"
                ringingContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: audioName))
                ringingContent.userInfo = [:]
                
                let rigingTrigger = UNCalendarNotificationTrigger(dateMatching: ringingDateComponent, repeats: true)
                
                let ringingRequest = UNNotificationRequest(identifier: ringingId, content: ringingContent, trigger: rigingTrigger)
                
                UNUserNotificationCenter.current().add(ringingRequest) {(error) in
                    if let error = error {
                        print("schedule alarm error : \(error)")
                    }
                }
                print("\(i): ===== main alarm's ringing pendings are scheduled =====")
            }
            
        }
    }
    
    func cancelNotification(id:String, repeatingDays:[Int], semaphore:DispatchSemaphore) {
        print("=================== cancelNotification called ===================")
        var ids:[String] = []
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests(completionHandler: { requests in
            
            for request in requests {
                if(request.identifier.contains("\(id)")){
                    ids.append(request.identifier)
                }
            }
            
            center.removeDeliveredNotifications(withIdentifiers: ids)
            center.removePendingNotificationRequests(withIdentifiers: ids)
            print("canceled notis : \(ids)")
            semaphore.signal()
            print("next line of semaphore signal")
        })
    }


    
    func cancelRingNotis(id:String){
        //print("debug : cancel ringing pendings => \(id)")
        
        var ids:[String] = []
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if request.identifier.contains("\(id)#"){
                    print("target : \(request.identifier)")
                    ids.append(request.identifier)
                }
            }
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
            print("\(ids) notis for ringing are canceled")
        })
    }
    
    
}
