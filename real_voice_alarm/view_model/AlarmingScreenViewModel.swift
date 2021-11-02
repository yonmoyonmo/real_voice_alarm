//
//  AlarmingScreenViewModel.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/02.
//

import Foundation

class AlarmingScreenViewModel: ObservableObject{
    let coreDataManager = CoreDataManager.instance
    @Published var currentAlarm:AlarmEntity = AlarmEntity()
    
}
