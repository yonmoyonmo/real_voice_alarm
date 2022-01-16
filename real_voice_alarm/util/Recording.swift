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
    "[기상] 당신이 일찍 일어나려 하는 이유는 무엇인가요?",
    "[기상] 오늘 점심은 뭘 먹을 거예요?",
    "[기상] 지금 내가 이루고 싶은 목표는 무엇인가요?",
    "[기상] 지금 바로 일어나면 꿈을 이룰 거예요",
    "[기상] 혹시 더 잘 핑계를 찾고 있지 않나요?",
    "[기상] 힘든 세상을 살아가야 할 나",
    "[응원] 오늘도 힘내요 우리",
    "[응원] 자신을 믿으세요",
    "[응원] 흔들려도 좋으니 꺾이지만 말아요",
    "[취침] 당신은 지금 어떤 선택을 할 건가요?",
    "[취침] 성공의 리듬",
    "[취침] 오늘 아침에도 ‘일찍 잘걸’하고 생각하지 않으셨나요?",
    "[취침] 오늘 하루는 어땠나요?",
    "[취침] 지금 자지 않으면"
]
