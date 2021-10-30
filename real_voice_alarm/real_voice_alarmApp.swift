//
//  real_voice_alarmApp.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/25.
//
/**
 해야할 것
 
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
    let coreDataManager = CoreDataManager.instance
    
    var audioPlayer = AudioPlayer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("app launched")
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    //foreground
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
        let alarmEntity = coreDataManager.findAlarmById(uuid: id)
        print(alarmEntity[0].audioURL!)
        recorderAlarm.isFiring = true
        //audioPlayer.startPlayback(audio: alarmEntity[0].audioURL!)
        print("+++++++++++++++++++++++++++++++++++++++")
        
        completionHandler(.list)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("##########################")
        print("background noti received")
        recorderAlarm.isFiring = true
        print("##########################")
    }
    
}
