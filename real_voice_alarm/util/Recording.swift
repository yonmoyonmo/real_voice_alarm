//
//  Recording.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import Foundation

struct Recording {
    let fileURL: URL
    let createdAt: Date
}

struct Sample{
    let sampleURL: String
    let sampleName: String
}

//정적인 자료이므로 하드코딩...
let sampleNames = [
    "흔들려도 좋으니",
    "오늘 점심은?",
    "내일 아침을 위해",
    "평범해 보이는 노력과 행동이",
    "혹시 더 잘 핑계를?",
    "지금 내가 이루고 싶은 목표는?",
    "미래는 지금의 선택",
    "성공의 리듬",
    "오늘 하루는 어땠나요?",
    "힘든 세상",
    "오늘 아침에도 일찍 잘걸",
    "일찍 일어나려는 이유는?",
    "혹시 10분만 더?",
    "자신을 믿으세요",
   
]
