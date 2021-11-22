//
//  AlarmingScreenViewModel.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/02.
//

import Foundation

class AlarmingScreenViewModel: ObservableObject{
    let coreDataManager = CoreDataManager.instance
    let recorderAlarm = RecorderAlarm.instance
    
    @Published var currentAlarm:AlarmEntity
    
    init(){
        currentAlarm = coreDataManager.findAlarmById(uuid: recorderAlarm.firingAlarmId)
    }
    
    func getCurrentAlarm(id:String){
        currentAlarm = coreDataManager.findAlarmById(uuid: id)
    }
    
}
