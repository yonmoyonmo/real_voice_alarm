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
    
    @Published var dayAlarms:[AlarmEntity] = []
    @Published var nightAlarms:[AlarmEntity] = []
    
    init(){
        getAlarms()
    }
    
    func getAlarms(){
        print("alarm fetched")
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
    }
}
