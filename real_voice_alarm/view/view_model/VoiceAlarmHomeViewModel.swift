//
//  VoiceAlarmViewModel.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/27.
//

import Foundation
import CoreData

class VoiceAlarmHomeViewModel: ObservableObject {
    
    let coreDataManager = CoreDataManager.instance
    let notificationManager = NotificationManager.instance
    let recorderAlarm = RecorderAlarm.instance
    
    @Published var dayAlarms:[AlarmEntity] = []
    @Published var nightAlarms:[AlarmEntity] = []
    @Published var isFull:Bool = false
    
    init(){
        getAlarms()
    }
    
    func getAlarms(){
        //fetch
        let dayRequest:NSFetchRequest<AlarmEntity>
        dayRequest = AlarmEntity.fetchRequest()
        dayRequest.predicate = NSPredicate(
            format: "isDay == %@", NSNumber(booleanLiteral: true)
        )
        
        let nightRequest:NSFetchRequest<AlarmEntity>
        nightRequest = AlarmEntity.fetchRequest()
        nightRequest.predicate = NSPredicate(
            format: "isDay == %@", NSNumber(booleanLiteral: false)
        )
        
        do{
            dayAlarms = try coreDataManager.context.fetch(dayRequest)
            nightAlarms = try coreDataManager.context.fetch(nightRequest)
        }catch let error {
            print("alarm fetching error : \(error.localizedDescription)")
        }
        //sort by isActive true
        dayAlarms.sort{ $0.isActive && !$1.isActive }
        nightAlarms.sort{ $0.isActive && !$1.isActive }
        let total = dayAlarms.count + nightAlarms.count
        if total >= 10 {
            print("Home VM : alarms count FULL \(total)")
            isFull = true
        }else{
            isFull = false
        }
        
        recorderAlarm.setLastingTimeOfNext()
    }
}
