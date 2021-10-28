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
    
    override init() {
        super.init()
        fatchRecordings()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioName: String?
    
    var recordings = [Recording]()
    
    func startRecording(title: String) {
        let fileManager = FileManager.default
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        }catch {
            print("failed to set up recording session")
        }
        
        //test : save file to /Library/Sounds/
        var documentPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        documentPath = documentPath.appendingPathComponent("Sounds")
        do {
            try fileManager.createDirectory(at: documentPath, withIntermediateDirectories: false, attributes: nil)
        }catch let e{
            print(e.localizedDescription)
        }
        //
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let audioFilename = documentPath.appendingPathComponent("\(title)_\(dateFormatter.string(from: Date())).m4a")
        
        audioName = "\(title)_\(dateFormatter.string(from: Date())).m4a"
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do{
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            recording = true
        }catch let error{
            print("Could not start recording : \(error.localizedDescription)")
        }
    }
    
    func stopRecording() -> String {
        audioRecorder.stop()
        recording = false
        fatchRecordings()
        return audioName!
    }
    
    func fatchRecordings() {
        recordings.removeAll()
        let fileManager = FileManager.default
        
        //find files in /Libray/Sounds/
        var documentDirectory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        
        //what's in this array
        let debug01 = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)
        for element in debug01 {
            print(element)
        }
        //
        
        documentDirectory = documentDirectory.appendingPathComponent("Sounds")
        //make dir /Library/Sounds/
        do {
            try fileManager.createDirectory(at: documentDirectory, withIntermediateDirectories: false, attributes: nil)
        }catch let e{
            print(e.localizedDescription)
        }
        
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        
        recordings.sort(by: {$0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        objectWillChange.send(self)
    }
    
    func deleteRecording(urlsToDelete: [URL]){
        for url in urlsToDelete {
            print(url)
            do{
                try FileManager.default.removeItem(at: url)
            }catch{
                print("File Could not be deleted")
            }
        }
        fatchRecordings()
    }
}
