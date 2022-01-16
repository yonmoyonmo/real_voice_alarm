//
//  GuideList.swift
//  real_voice_alarm
//
//  Created by yonmo on 2022/01/16.
//

import SwiftUI

struct GuideList: View {
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
                    title: "모티보이스, 이렇게도 사용할 수 있어요",
                    content:"조금만 더 자야지’ 하다가 늘 출근 지하철까지 힘들게 뛰어가는 나, 새벽에 즐기는 달콤한 휴대폰 타임에 다음날 점심까지 피곤해서 헤롱헤롱하던 나. 모두가 공감하는 우리의 모습 아닐까요? 이렇게 우리는 아침마다, 혹은 밤마다 내 다짐을 흐릿하게 하는 유혹의 순간들과 매일 마주합니다. 모티보이스는 이러한 시간마다 내 목소리를 들려줌으로써, 다시 한번 내 다짐을 떠올리게끔 도와드립니다. 그리고 미래의 나에게 메시지를 보내며, 다짐을 잊지 않도록, 같은 실수를 반복하지 않도록 나를 응원할 수도 있습니다. 모티보이스와 함께 내 목소리로 내 하루를 만들어보세요."
                )
                ){
                    Text("모티보이스, 이렇게도 사용할 수 있어요").foregroundColor(Color.textBlack)
                }
                NavigationLink(destination: QandADetail(
                    title: "낮과 밤의 알림이 나누어져 있는 이유",
                    content:"모티보이스는 아침마다 반복되는 ‘어제 일찍 잘걸’하는 후회에서 시작되었습니다. 밤에도 이런 아침의 마음가짐을 가져올 수는 없을까 고민하였습니다. 아침에는 더 자고 싶고, 밤에는 조금만 더 휴대폰을 보고 싶고.. 이렇게 각 시간마다 우리에게 찾아오는 유혹은 다릅니다. 그렇다면 낮과 밤에 필요한 내 목소리도 다르지 않을까 하는 생각에 모티보이스는 낮과 밤의 알림을 구분했답니다. 모티보이스를 통해 오늘 밤의 나에게, 내일 아침의 나에게 응원의 메시지를 보내보세요."
                )
                ){
                    Text("낮과 밤의 알림이 나누어져 있는 이유").foregroundColor(Color.textBlack)
                }
                NavigationLink(destination: QandADetail(
                    title: "적절한 녹음의 길이",
                    content:"알림의 적절한 녹음 길이는 알림간 반복 간격을 고려하여, 11초 내외를 추천드립니다."
                )
                ){
                    Text("적절한 녹음의 길이").foregroundColor(Color.textBlack)
                }
                NavigationLink(destination: QandADetail(
                    title: "배경 테마 변경",
                    content:"설정 아이콘 → 앱 테마 바꾸기에서 내 취향에 맞는 앱 테마로 변경할 수 있습니다."
                )
                ){
                    Text("배경 테마 변경").foregroundColor(Color.textBlack)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

