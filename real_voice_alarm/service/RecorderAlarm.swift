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
    
    @Published var isFiring: Bool = false
    
    func saveAlarm(tagName:String, fireAt: Date, audioName: String, audioURL: URL) {
        
        notificationManager.requestAuthorization()
        
        let id:UUID = UUID()
        
        let newAlarm = AlarmEntity(context: coreDataManager.context)
        newAlarm.tagName = tagName
        newAlarm.fireAt = fireAt
        newAlarm.audioName = audioName
        newAlarm.isDay = false
        newAlarm.repeatingDays = ""
        newAlarm.uuid = id.uuidString
        newAlarm.audioURL = audioURL
       
        notificationManager.scheduleAlarm(tagName: tagName, fireAt: fireAt, audioName: audioName, id: id.uuidString)
       
        coreDataManager.save(savedEntity: tagName)
        
        print("alarm saved and sheduled")
    }
    
}
