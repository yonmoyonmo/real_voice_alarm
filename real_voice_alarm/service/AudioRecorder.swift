//
//  AudioRecorder.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    
    static let instance = AudioRecorder()
    
    override init() {
        super.init()
        fatchRecordings()
        fetchSamples()
        print("audio recorder initialized")
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }

    var audioFilename: URL?
    var audioName: String = ""
    
    var recordings = [Recording]()
    var samples = [Sample]()
    
    func requestMicrophonePermission(){
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Mic: 권한 허용")
                } else {
                    print("Mic: 권한 거부")
                }
            })
        }
    
    func startRecording(title: String) {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        }catch {
            print("failed to set up recording session")
        }
        
        //saving file to /Library/Sounds/
        var documentPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        documentPath = documentPath.appendingPathComponent("Sounds")
        
        //let nowDate = Date()
        audioFilename = documentPath.appendingPathComponent("\(title).m4a")
        audioName = "\(title).m4a"
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do{
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder.record()//forDuration: 29 듀레이션을 줄 지 말지 고민 중 : 듀레이션은 녹음 시간 제한하는 것임
            recording = true
        }catch let error{
            print("Could not start recording : \(error.localizedDescription)")
        }
    }
    

    func stopRecording() -> [String:Any]{
        audioRecorder.stop()
        recording = false
        fatchRecordings()
        var audioData: [String:Any] = [:]
        audioData["audioName"] = self.audioName
        audioData["audioURL"] = self.audioFilename
        return audioData
    }
    
    
    func changeAudioFileName(audioName: String, audioURL: URL?) -> [String:Any]{
        var result:[String:Any] = [:]
        let originalFileURL:URL = audioURL!
        
        do{
            let fileManager = FileManager.default
            var documentDirectory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            documentDirectory = documentDirectory.appendingPathComponent("Sounds")
            
            var newAudioFileURL:URL
            
            if(audioName.count < 4){
                newAudioFileURL = documentDirectory.appendingPathComponent("\(audioName).m4a")
            }else{
                let index = audioName.index(audioName.endIndex, offsetBy: -4)
                let extensionString = audioName[index...]
                if(extensionString != ".m4a"){
                    newAudioFileURL = documentDirectory.appendingPathComponent("\(audioName).m4a")
                }else{
                    newAudioFileURL = documentDirectory.appendingPathComponent("\(audioName)")
                }
            }
            
            let path = newAudioFileURL.path
            
            //파일 이름 중복 예외처리
            if(fileManager.fileExists(atPath: path)){
                print("<< 녹음 파일 이름 중복된다 >>")
                let newAudioName = "\(audioName)+\(Date())"
                newAudioFileURL = documentDirectory.appendingPathComponent("\(newAudioName).m4a")
                
                try fileManager.moveItem(at: originalFileURL, to: newAudioFileURL)
                
                result["audioNewName"] = newAudioName
                result["audioNewURL"] = newAudioFileURL
            }else{
                try fileManager.moveItem(at: originalFileURL, to: newAudioFileURL)
                
                if(originalFileURL == newAudioFileURL){
                    result["audioNewName"] = audioName
                    result["audioNewURL"] = originalFileURL
                }
                
                result["audioNewName"] = audioName
                result["audioNewURL"] = newAudioFileURL
            }
        }catch let error{
            print("changeAudioFileName :\(error)")
        }
        return result
    }
    
    func fatchRecordings() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        var documentDirectory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        documentDirectory = documentDirectory.appendingPathComponent("Sounds")

        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        
        recordings.sort(by: {$0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        objectWillChange.send(self)
    }
    
    func fetchSamples(){
        samples.removeAll()
        //14개의 샘플입니다.
        for i in 0...13 {
            //this relative path is playable anyway... and it's string...
            let sampleURL = Bundle.main.path(forResource: "\(i)", ofType: "wav")!
            let sample = Sample(sampleURL: sampleURL, sampleName: "\(sampleNames[i]).wav")
            //print("fetchSamples debug sample values : URL = \(sampleURL) || name = \(sampleNames[i])")
            samples.append(sample)
        }
        
        objectWillChange.send(self)
    }
    
    func deleteRecording(urlsToDelete: [URL]){
        for url in urlsToDelete {
            do{
                try FileManager.default.removeItem(at: url)
            }catch let error{
                print("File Could not be deleted : \(error)")
            }
        }
        fatchRecordings()
    }
}
