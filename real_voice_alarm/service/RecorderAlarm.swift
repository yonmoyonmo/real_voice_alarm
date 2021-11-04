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
    @Published var isFiring: Bool = false
    
    init(){
        print("recorder alarm instance is created")
    }
    
    //00시 - 12시(am) == day
    //12시 1분 ~ 23시 59분(pm) == night
    func isDay(fireAt: Date)->Bool{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: fireAt)
        if 12 < hour {
            return false
        }else {
            return true
        }
    }
    
    func saveAlarm(tagName:String, fireAt: Date, audioName: String, audioURL: URL, volume: Double) {
        let id:UUID = UUID()
        
        let newAlarm = AlarmEntity(context: coreDataManager.context)
        newAlarm.tagName = tagName
        newAlarm.fireAt = fireAt
        newAlarm.audioName = audioName
        newAlarm.isDay = isDay(fireAt: fireAt)
        newAlarm.repeatingDays = ""
        newAlarm.uuid = id.uuidString
        newAlarm.audioURL = audioURL
        newAlarm.volume = volume
       
        notificationManager.scheduleAlarm(tagName: tagName, fireAt: fireAt, audioName: audioName, id: id.uuidString)
        
        coreDataManager.save(savedAlarmName: tagName)
        
        print("alarm saved and sheduled")
    }
    
    func deleteAlarm(id:String){
        //아이디로 알람데이터와 노티를 찾아 갈 수 있음
        //알람 삭제하고, 스케쥴 된 노티 삭제
        coreDataManager.deleteTargetEntity(id: id)
        notificationManager.cancelNotification(id: id)
    }
    
   
    
}

