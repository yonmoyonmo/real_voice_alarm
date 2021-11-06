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
        let content = UNMutableNotificationContent()
        content.title = "MOTIVOICE IS ARRIVED!"
        content.subtitle = "\(tagName)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: audioName))
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireAt)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
    //리피팅 알람 세팅
    func scheduleRepeatingAlarms(dates: [Date],tagName:String, id:String, audioName:String) {
        
        var componentsToSaveList:[DateComponents] = []
        for date in dates {
            componentsToSaveList.append(Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date))
        }
        
        for componentsToSave in componentsToSaveList {
            let repeatingId = RepeatDays(rawValue: componentsToSave.weekday!)?.fullName
            let devider:String = "@"
            let newId = id + devider + repeatingId!
            let trigger = UNCalendarNotificationTrigger(dateMatching: componentsToSave, repeats: true)
            
            let content = UNMutableNotificationContent()
            content.title = "MOTIVOICE IS ARRIVED!"
            content.body = "\(tagName)"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: audioName))
            
            let request = UNNotificationRequest(identifier: newId, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {(error) in
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                }
            }
            print(newId + " is schduled")
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
        print("alarm id \(id) is removed")
    }
}
