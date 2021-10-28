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
    @Published var alarms:[AlarmEntity] = []
    
    init(){
        getAlarms()
    }
    
    func getAlarms(){
        let request = NSFetchRequest<AlarmEntity>(entityName: "AlarmEntity")
        do{
            alarms = try coreDataManager.context.fetch(request)
            print("alarms fetched")
        }catch let error {
            print("voice Alarm Home View Model alarm fetching error : \(error.localizedDescription)")
        }
    }
}
