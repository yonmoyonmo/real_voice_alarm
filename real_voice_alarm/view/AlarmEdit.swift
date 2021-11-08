//
//  AlarmEdit.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/08.
//

import SwiftUI

struct AlarmEdit: View {
    var alarm: AlarmEntity
    var vm: VoiceAlarmHomeViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AlarmEdit_Previews: PreviewProvider {
    static var previews: some View {
        AlarmEdit(alarm: AlarmEntity(), vm: VoiceAlarmHomeViewModel())
    }
}
