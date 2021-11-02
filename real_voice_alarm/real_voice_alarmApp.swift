//
//  real_voice_alarmApp.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/25.
//
/**
메모장
 */
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
    let notificationManager = NotificationManager.instance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("app launched")
        UNUserNotificationCenter.current().delegate = self
        notificationManager.requestAuthorization()
        return true
    }
    
    //foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("noti delegate debug++++++++++++++++++++")
        print("foreground notification received")
        
        let id:String = notification.request.identifier
        print(id)
        recorderAlarm.isFiring = true
        recorderAlarm.firingAlarmId = id
        
        print("+++++++++++++++++++++++++++++++++++++++")
        
        completionHandler(.list)
    }
    //background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("##########################")
        print("background noti received")
        
        let id:String = response.notification.request.identifier
        print(id)
        recorderAlarm.isFiring = true
        recorderAlarm.firingAlarmId = id
        
        print("##########################")
        
        completionHandler()
    }
    
}
