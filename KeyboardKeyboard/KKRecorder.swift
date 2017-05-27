//
//  KKRecorder.swift
//  KeyboardKeyboard
//
//  Created by KaHo Yeung on 27/5/2017.
//  Copyright © 2017 TYKH. All rights reserved.
//

import Foundation
import AudioKit


class KKRecorder {
    static let sharedInstance = KKRecorder()
    
    var recorder : AKNodeRecorder?
    
    var file : AKAudioFile?
    
    var player:AKAudioPlayer?
    
    init () {
        recorder = nil
        file = nil
        player = nil
    }
    
    func startRecording() {
        do{
        let dateElements = NSDate.init().description.components(separatedBy: " ")
        var fileName = "KKRecord_" + dateElements[0]+"_"+dateElements[1]
        fileName = fileName.replacingOccurrences(of: ":", with: "-") + ".wav"
        
        let file = try AKAudioFile()//forWriting: NSURL.fileURL(withPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + fileName) , settings: [AVLinearPCMBitDepthKey:16]
            
        let recorder = try AKNodeRecorder(node: KKInstrument.sharedInstance.mixer, file: file)
        KKRecorder.sharedInstance.recorder = recorder
        KKRecorder.sharedInstance.file = file
        KKRecorder.sharedInstance.player = try AKAudioPlayer(file: file)
        KKInstrument.sharedInstance.mixer.connect(KKRecorder.sharedInstance.player)
            
        } catch {
            AKLog("Couldn't initialize recorder")
        }
        
        do{
            try recorder!.record()
        } catch {
            AKLog("Couldn't record")
            
            NSAlert(error: error).runModal()
        }
    }
    
    func stopRecording() {
        if recorder!.isRecording {
            recorder!.stop()
        }
    }
    
    func playRecording() {
        do {try player!.reloadFile()} catch{}
        player!.play()
    }
    
    func saveRecording() {
        
        let dateElements = NSDate.init().description.components(separatedBy: " ")
        var fileName = "KKRecord_" + dateElements[0]+"_"+dateElements[1]
        fileName = fileName.replacingOccurrences(of: ":", with: "-") + ".m4a"
        
        
        let exporter = AVAssetExportSession(asset: file!.avAsset, presetName: AVAssetExportPresetHighestQuality)
        
        let documentsDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
        
        let outputURL = documentsDirectory.appendingPathComponent(fileName)
        
        exporter?.outputURL = outputURL
        exporter?.outputFileType = AVFileTypeMPEG4
        
        exporter?.exportAsynchronously(completionHandler: {})
        
    }
    
}
