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
        
        //델리게이트 등록
        UNUserNotificationCenter.current().delegate = self
        
        //노티피케이션 권한 요청
        notificationManager.requestAuthorization()
        
        //-------목소리 저장할 directory 맨들기-------//
        let fileManager = FileManager.default
        var documentDirectory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        documentDirectory = documentDirectory.appendingPathComponent("Sounds")
        
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: documentDirectory.absoluteString, isDirectory:&isDir) {
            if isDir.boolValue {
                // file exists and is a directory
                print("\(documentDirectory.absoluteString) exists")
            } else {
                // file exists and is not a directory
                print("\(documentDirectory.absoluteString) exists but it's a file")
            }
        }else{
            do {
                print("\(documentDirectory.absoluteString) dose not exists. creating directory.")
                try fileManager.createDirectory(at: documentDirectory, withIntermediateDirectories: false, attributes: nil)
            }catch let e{
                print(e.localizedDescription)
            }
        }
        //-------------------------------//
        
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
        var newId:String = ""
        print(id)
        if id.contains("@"){
            let deviderIndex:String.Index = id.firstIndex(of: "@")!
            newId = String(id[...deviderIndex])
            
            if let i = newId.firstIndex(of: "@"){
                newId.remove(at: i)
            }
            print(newId)
            recorderAlarm.isFiring = true
            recorderAlarm.firingAlarmId = newId
        }else{
            recorderAlarm.isFiring = true
            recorderAlarm.firingAlarmId = id
        }
        print("+++++++++++++++++++++++++++++++++++++++")
        
        //list가 뭔지 아직 모름
        completionHandler(.list)
    }
    //background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("##########################")
        print("background noti received")
        
        let id:String = response.notification.request.identifier
        var newId:String = ""
        print(id)
        if id.contains("@"){
            let deviderIndex:String.Index = id.firstIndex(of: "@")!
            newId = String(id[...deviderIndex])
            
            if let i = newId.firstIndex(of: "@"){
                newId.remove(at: i)
            }
            
            print(newId)
            recorderAlarm.isFiring = true
            recorderAlarm.firingAlarmId = newId
        }else{
            recorderAlarm.isFiring = true
            recorderAlarm.firingAlarmId = id
        }
        print("##########################")
        
        completionHandler()
    }
    
}
