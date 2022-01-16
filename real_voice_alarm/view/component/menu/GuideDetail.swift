//
//  GuideDetail.swift
//  real_voice_alarm
//
//  Created by yonmo on 2022/01/16.
//

import SwiftUI

struct GuideDetail: View {
    let title:String
    let content:String
    
    var body: some View {
        VStack{
            Text(title)
            Text(content)
        }
    }
}

