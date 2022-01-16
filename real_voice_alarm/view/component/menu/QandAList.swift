//
//  QandAMenu.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/12/19.
//

import SwiftUI

struct QandAList: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            HStack(){
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("← Back").foregroundColor(Color.textBlack)
                    Spacer()
                })
            }.padding(.top).padding(.horizontal)
            List{
                NavigationLink(destination: QandADetail(
                    title: "알림이 오지 않아요, 알림 소리가 안나요",
                    content:"혹시 휴대폰이 방해금지모드로 설정되어 있지는 않나요? IOS 정책상, 방해금지모드에서는 모티보이스가 알림을 보낼 수 없습니다. 알림은 오는데, 소리가 나지 않는다면 휴대폰이 무음모드로 설정되어 있지는 않은지 확인해 보세요. 모티보이스가 최신 버전인지 업데이트 여부를 확인해주세요"
                )
                ){
                    Text("알림이 오지 않아요, 알림 소리가 안나요").foregroundColor(Color.textBlack)
                }
                NavigationLink(destination: QandADetail(
                    title: "알림 소리가 너무 작아요",
                    content:"미디어 음량을 키우면 모티보이스 알림 음량을 키울 수 있습니다."
                )
                ){
                    Text("알림 소리가 너무 작아요").foregroundColor(Color.textBlack)
                }
                NavigationLink(destination: QandADetail(
                    title: "알림은 몇 개까지 만들 수 있나요?",
                    content:"알림은 최대 10개까지 설정할 수 있습니다."
                )
                ){
                    Text("알림은 몇 개까지 만들 수 있나요?").foregroundColor(Color.textBlack)
                }
                NavigationLink(destination: QandADetail(
                    title: "성우 음성은 더 업데이트 되나요?",
                    content:"모티보이스는 유저 여러분들의 수요에 따라 더 많은 목소리들을 제공해드릴 수 있도록 준비하고 있습니다. 기대해주세요! 혹시 듣고 싶은 메시지가 있다면, team.ataraxias@gmail.com 으로 보내주세요!"
                )
                ){
                    Text("성우 음성은 더 업데이트 되나요?").foregroundColor(Color.textBlack)
                }
            }
            .navigationBarHidden(true)
        }
    }
}


