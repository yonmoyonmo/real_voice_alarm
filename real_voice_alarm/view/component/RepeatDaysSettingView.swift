//
//  RepeatDaysSettingView.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/06.
//

import SwiftUI

struct RepeatDaysSettingView: View {
    @Binding var repeatDays: [RepeatDays]
    
    @State var selectedSun: Bool = false
    @State var selectedMon: Bool = false
    @State var selectedTue: Bool = false
    @State var selectedWed: Bool = false
    @State var selectedThu: Bool = false
    @State var selectedFri: Bool = false
    @State var selectedSat: Bool = false
    
    func setForEdit(){
        if repeatDays.contains(.sunday){
            self.selectedSun = true
        }else{
            self.selectedSun = false
        }
        
        if repeatDays.contains(.monday){
            self.selectedMon = true
        }else{
            self.selectedMon = false
        }
        
        if repeatDays.contains(.tuesday){
            self.selectedTue = true
        }else{
            self.selectedTue = false
        }
        
        if repeatDays.contains(.wednesday){
            self.selectedWed = true
        }else{
            self.selectedWed = false
        }
        
        if repeatDays.contains(.thursday){
            self.selectedThu = true
        }else{
            self.selectedThu = false
        }
        
        if repeatDays.contains(.friday){
            self.selectedFri = true
        }else{
            self.selectedFri = false
        }
        
        if repeatDays.contains(.saturday){
            self.selectedSat = true
        }else{
            self.selectedSat = false
        }
    }
    
    
    
    var body: some View {
        HStack{
            //----------//
            if selectedSun {
                Button(action: {
                    if let index = repeatDays.firstIndex(of: .sunday){
                        repeatDays.remove(at: index)
                    }
                    selectedSun.toggle()
                }, label: {
                    Text("일").foregroundColor(.red)
                })
            }else{
                Button(action: {
                    repeatDays.append(.sunday)
                    selectedSun.toggle()
                }, label: {
                    Text("일")
                })
            }
            //----------//
            if selectedMon {
                Button(action: {
                    if let index = repeatDays.firstIndex(of: .monday){
                        repeatDays.remove(at: index)
                    }
                    selectedMon.toggle()
                }, label: {
                    Text("월").foregroundColor(.red)
                })
            }else{
                Button(action: {
                    repeatDays.append(.monday)
                    selectedMon.toggle()
                }, label: {
                    Text("월")
                })
            }
            //----------//
            if selectedTue {
                Button(action: {
                    if let index = repeatDays.firstIndex(of: .tuesday){
                        repeatDays.remove(at: index)
                    }
                    selectedTue.toggle()
                }, label: {
                    Text("화").foregroundColor(.red)
                })
            }else{
                Button(action: {
                    repeatDays.append(.tuesday)
                    selectedTue.toggle()
                }, label: {
                    Text("화")
                })
            }
            //----------//
            if selectedWed {
                Button(action: {
                    if let index = repeatDays.firstIndex(of: .wednesday){
                        repeatDays.remove(at: index)
                    }
                    selectedWed.toggle()
                }, label: {
                    Text("수").foregroundColor(.red)
                })
            }else{
                Button(action: {
                    repeatDays.append(.wednesday)
                    selectedWed.toggle()
                }, label: {
                    Text("수")
                })
            }
            //----------//
            if selectedThu {
                Button(action: {
                    if let index = repeatDays.firstIndex(of: .thursday){
                        repeatDays.remove(at: index)
                    }
                    selectedThu.toggle()
                }, label: {
                    Text("목").foregroundColor(.red)
                })
            }else{
                Button(action: {
                    repeatDays.append(.thursday)
                    selectedThu.toggle()
                }, label: {
                    Text("목")
                })
            }
            //----------//
            if selectedFri {
                Button(action: {
                    if let index = repeatDays.firstIndex(of: .friday){
                        repeatDays.remove(at: index)
                    }
                    selectedFri.toggle()
                }, label: {
                    Text("금").foregroundColor(.red)
                })
            }else{
                Button(action: {
                    repeatDays.append(.friday)
                    selectedFri.toggle()
                }, label: {
                    Text("금")
                })
            }
            //----------//
            if selectedSat {
                Button(action: {
                    if let index = repeatDays.firstIndex(of: .saturday){
                        repeatDays.remove(at: index)
                    }
                    selectedSat.toggle()
                }, label: {
                    Text("토").foregroundColor(.red)
                })
            }else{
                Button(action: {
                    repeatDays.append(.saturday)
                    selectedSat.toggle()
                }, label: {
                    Text("토")
                })
            }
            
        }.onAppear(){
            setForEdit()
        }
    }
}
