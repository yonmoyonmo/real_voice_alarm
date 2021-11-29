//
//  MotivoiceTimer.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/29.
//

import Foundation
import SwiftUI
import Combine

class MotivoiceTimer{
    var value: Int = 0
    
    init(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
            self.value += 1
        }
    }
}
