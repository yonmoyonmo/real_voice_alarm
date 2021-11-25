//
//  AlarmingScreenViewModel.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/02.
//

import Foundation
import CoreData

class AlarmingScreenViewModel: ObservableObject{
    let coreDataManager = CoreDataManager.instance
    let recorderAlarm = RecorderAlarm.instance
    
    @Published var currentAlarm:AlarmEntity?
    
    init(){
        getCurrentAlarm()
    }
    
    func getCurrentAlarm(){
        if(recorderAlarm.firingAlarmId == ""){
            return
        }
        print("in vm getCurrent")
        print("firing alarm ID : \(recorderAlarm.firingAlarmId)")
        
        let currentAlarmRequest:NSFetchRequest<AlarmEntity>
        currentAlarmRequest = AlarmEntity.fetchRequest()
        currentAlarmRequest.predicate = NSPredicate(
            format: "uuid == %@", recorderAlarm.firingAlarmId
        )
        do{
            currentAlarm = try coreDataManager.context.fetch(currentAlarmRequest)[0]
        }catch let error {
            print("getCurrentAlarm error : \(error.localizedDescription)")
        }
        print(currentAlarm!.tagName!)
    }
    
}


