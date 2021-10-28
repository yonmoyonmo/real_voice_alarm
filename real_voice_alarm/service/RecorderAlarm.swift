//
//  RecorderAlarm.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import Foundation
import AVFoundation
import UserNotifications

/*
 오늘 해야할 것
 알람 스케쥴 만들고 데이터 생성하기
    알람 만들 때 필요한 녹음기 만들기
 */

class RecorderAlarm {
    static let instance = RecorderAlarm();
    let coreDataManager = CoreDataManager.instance;
    let notificationManager = NotificationManager.instance;
    
    func saveAlarm(tagName:String, fireAt: Date, audioName: String) {
        
        notificationManager.requestAuthorization()
        
        let id:UUID = UUID()
        print("debug, saveAlarm function, uuid : " + id.uuidString)
        
        let newAlarm = AlarmEntity(context: coreDataManager.context)
        newAlarm.tagName = tagName
        newAlarm.fireAt = fireAt
        newAlarm.audioName = audioName
        newAlarm.isDay = false
        newAlarm.repeatingDays = ""
        newAlarm.uuid = id
       
        notificationManager.scheduleAlarm(tagName: tagName, fireAt: fireAt, audioName: audioName, id: id.uuidString)
       
        coreDataManager.save(savedEntity: tagName)
        
        print("alarm saved and sheduled")
    }
    
    
}
