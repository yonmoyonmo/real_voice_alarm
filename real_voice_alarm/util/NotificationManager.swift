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
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
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
        content.title = "Voice Alarm Test"
        content.subtitle = "아이고 머리야~ 동비 한의원."
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: audioName))
        
        print("debug fireAt Date")
        print(fireAt)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireAt)
        print(dateComponents)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //identifier를 놓치지 말라, 알람 데이터와 같게 하라.
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        
        
    }
    
    func cancelNotification() {
        //UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: "돠네")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
