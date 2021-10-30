//
//  real_voice_alarmApp.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/25.
//

import SwiftUI

@main
struct real_voice_alarmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            VoiceAlarmHome()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let recorderAlarm = RecorderAlarm.instance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("app launched")
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
             willPresent notification: UNNotification,
             withCompletionHandler completionHandler:
                @escaping (UNNotificationPresentationOptions) -> Void) {
        print("noti delegate debug++++++++++++++++++++")
        print("foreground notification received")
        
        let title:String = notification.request.content.title
        let id:String = notification.request.identifier
        print(title)
        print(id)
        recorderAlarm.isFiring = true
        
        print("+++++++++++++++++++++++++++++++++++++++")
        
        completionHandler(.banner)
       }
}
