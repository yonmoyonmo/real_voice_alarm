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
                print("Error \(error)")
            }else{
                print("success")
            }
        }
    }
    
    func scheduleAlarm(tagName:String, fireAt: Date, audioName: String, id: String) {
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .weekday, .second], from: fireAt)
        dateComponents.second = 0
        
        let content = UNMutableNotificationContent()
        content.title = "MOTIVOICE IS ARRIVED!"
        content.subtitle = "\(tagName)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: audioName))
        content.userInfo = [
            "year" : "\(dateComponents.year!)",
            "weekday": "\(dateComponents.weekday!)",
            "hour":"\(dateComponents.hour!)",
            "minute":"\(dateComponents.minute!)"
        ]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("schedule alarm error : \(error)")
            }
        }
    }
    
    //리피팅 알람 세팅
    func scheduleRepeatingAlarms(dates: [Date],tagName:String, id:String, audioName:String) {
        var componentsToSaveList:[DateComponents] = []
        let content = UNMutableNotificationContent()
        
        for date in dates {
            componentsToSaveList.append(Calendar.current.dateComponents([.weekday,.hour,.minute,.second, .year], from: date))
        }
        
        for var componentsToSave in componentsToSaveList {
            let repeatingId = RepeatDays(rawValue: componentsToSave.weekday!)?.fullName
            let devider:String = "@"
            let newId = id + devider + repeatingId!
            componentsToSave.second = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: componentsToSave, repeats: true)
            
            content.title = "MOTIVOICE IS ARRIVED!"
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
        }
    }
    
    func cancelNotification(id:String, repeatingDays:[Int]) {
        var ids:[String] = [id]
        if(!repeatingDays.isEmpty){
            for repeatingDay in repeatingDays {
                let devider = "@"
                ids.append(id+devider+RepeatDays(rawValue: repeatingDay)!.fullName)
            }
        }
        
        print(ids)
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        print("alarm id \(id) is unscheduled")
    }
    
    
}
