//
//  real_voice_alarmApp.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/25.
//
/**
 메모장
 
 그리고 겟알람쓰가 너무 많이 호출 되는 부분도 고치자
 
 삭제된 알람이 스케쥴에 남아있기도 하네? 시발
 */
import SwiftUI
import AVFoundation

//screen size : width == 744.0, height == 1133.0 mini size

@main
struct real_voice_alarmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            VoiceAlarmHome().environmentObject(VoiceAlarmHomeViewModel())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let recorderAlarm = RecorderAlarm.instance
    let notificationManager = NotificationManager.instance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("------------------------< App Launched >------------------------")
        
        //print("screen size : width == \(UIScreen.screenWidth), height == \(UIScreen.screenHeight)")
        
        //노티피케이션 델리게이트 등록
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
                print("error in making directory \(e.localizedDescription)")
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
        
        print("-------------------------[ foreground notification received ]-------------------------")
        
        let originalId:String = notification.request.identifier
        var shopRemovedId:String = ""
        var atRemovedId:String = ""
        
        //#으로 구분된 것 짤라주기
        if(originalId.contains("#")){
            print("foreground noti contains '#' \(originalId)")
            let deviderIndex:String.Index = originalId.firstIndex(of: "#")!
            shopRemovedId = String(originalId[...deviderIndex])
            
            if let i = shopRemovedId.firstIndex(of: "#"){
                shopRemovedId.remove(at: i)
            }
            
            print("foreground noti '#' removed \(shopRemovedId)")
        }else{
            shopRemovedId = originalId
        }
        
        if shopRemovedId.contains("@"){
            let deviderIndex:String.Index = shopRemovedId.firstIndex(of: "@")!
            atRemovedId = String(shopRemovedId[...deviderIndex])
            if let i = atRemovedId.firstIndex(of: "@"){
                atRemovedId.remove(at: i)
            }
            print(atRemovedId)
            recorderAlarm.repeatingAlarmId = shopRemovedId
            recorderAlarm.isFiring = true
            recorderAlarm.firingAlarmId = atRemovedId
        }else{
            print("foreground noti \(shopRemovedId)")
            recorderAlarm.repeatingAlarmId = ""
            recorderAlarm.isFiring = true
            recorderAlarm.firingAlarmId = shopRemovedId
        }
        print("---------------------------------------------------------------------------")
        
        completionHandler(.list)
    }
    
    //background, when touch the noti bar
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("-------------------------[ background noti received ]-------------------------")
        
        let originalId:String = response.notification.request.identifier
        var shopRemovedId:String = ""
        var atRemovedId:String = ""
        
        //#으로 구분된 것 짤라주기
        if(originalId.contains("#")){
            print("backgrond noti contains '#' \(originalId)")
            let deviderIndex:String.Index = originalId.firstIndex(of: "#")!
            shopRemovedId = String(originalId[...deviderIndex])
            if let i = shopRemovedId.firstIndex(of: "#"){
                shopRemovedId.remove(at: i)
            }
            print("backgrond noti '#' removed \(shopRemovedId)")
        }else{
            shopRemovedId = originalId
        }
        
        
        if shopRemovedId.contains("@"){
            let deviderIndex:String.Index = shopRemovedId.firstIndex(of: "@")!
            atRemovedId = String(shopRemovedId[...deviderIndex])
            
            if let i = atRemovedId.firstIndex(of: "@"){
                atRemovedId.remove(at: i)
            }
            recorderAlarm.repeatingAlarmId = shopRemovedId
            recorderAlarm.isFiring = true
            recorderAlarm.firingAlarmId = atRemovedId
        }else{
            print("backgrond noti \(shopRemovedId)")
            recorderAlarm.repeatingAlarmId = ""
            recorderAlarm.isFiring = true
            recorderAlarm.firingAlarmId = shopRemovedId
        }
        print("---------------------------------------------------------------------------")
        
        completionHandler()
    }
    
}
