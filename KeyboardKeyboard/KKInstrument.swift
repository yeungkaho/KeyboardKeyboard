//
//  KKInstrument.swift
//  KeyboardKeyboard
//
//  Created by Yeung Ka Ho on 16/2/19.
//  Copyright © 2016年 TYKH. All rights reserved.
//

import Foundation
import AudioKit
import CoreAudioKit
class KKInstrument {
    
    static let sharedInstance = KKInstrument()
    
    weak var window:NSWindow?
    
    let keyMap:Dictionary<UInt16,Int> = [
        6:0,
        1:1,
        7:2,
        2:3,
        8:4,
        9:5,
        5:6,
        11:7,
        4:8,
        45:9,
        38:10,
        46:11,
        43:12,
        37:13,
        47:14,
        41:15,
        44:16,
        12:12,
        19:13,
        13:14,
        20:15,
        14:16,
        15:17,
        23:18,
        17:19,
        22:20,
        16:21,
        26:22,
        32:23,
        34:24,
        25:25,
        31:26,
        29:27,
        35:28,
        33:29,
        24:30,
        30:31,
        51:32,
        42:33
    ]
    
    var activeNotesByKeyCode = [UInt16:Int]()
    
    var octaveOffset = 5
    
    var token: Int = 0
    
    var isMonophonic = false
    
    var instrument:AKPolyphonicNode? {
        didSet{
            for (_,note) in activeNotesByKeyCode{
                oldValue!.stop(noteNumber: MIDINoteNumber(note))
            }
            activeNotesByKeyCode.removeAll()
            keyList.removeAll()
        }
    }
    
    
    var mixer = AKMixer()
    var outMixer = AKMixer()
    fileprivate init () {
        outMixer.connect(mixer)
        AudioKit.output = outMixer
        AudioKit.start()
    }
    
    func keyUp(_ theEvent: NSEvent) {
        if keyMap[theEvent.keyCode] == nil {
            return
        }
        
        if let note = activeNotesByKeyCode[theEvent.keyCode] {
            instrument!.stop(noteNumber: MIDINoteNumber(note))
        }
        
        activeNotesByKeyCode.removeValue(forKey: theEvent.keyCode)
        
        if isMonophonic {
            
            if theEvent.keyCode == lastKey() {
                popKeyCode()
                let lastKeyCode = lastKey()
                let lastNote = activeNotesByKeyCode[lastKeyCode]
                if (lastNote != nil) {
                    instrument!.play(noteNumber: MIDINoteNumber(lastNote!), velocity: 127)
                }
            } else {
                dropKey(theEvent.keyCode)
            }
        }
    }
    
    func keyDown(_ theEvent: NSEvent) {
        if theEvent.isARepeat || theEvent.modifierFlags.contains(.command){
            //ignore repeats or command key shortcuts
            return
        }
        
        
        if theEvent.keyCode == 48 {
            //tab
            if (octaveOffset < 10){
                octaveOffset += 1
            }
            return
        } else if theEvent.keyCode == 49 {
            //space
            if (octaveOffset > 1){
                octaveOffset -= 1
            }
            return
        } else if theEvent.keyCode == 53 {
            //esc:kills all sound
            killAll()
            return
        } else if theEvent.keyCode == 50 {
            //`:mono/poly switch
            killAll()
            isMonophonic = !isMonophonic
            window!.title = "KeyboardKeyboard" + (isMonophonic ? "(mono)":"")
            return
        } else if theEvent.keyCode == 98 {
            //F7: play recording
            KKRecorder.sharedInstance.playRecording()
            return
        } else if theEvent.keyCode == 100 {
            //F8: start recording
            KKRecorder.sharedInstance.startRecording()
            return
        } else if theEvent.keyCode == 101 {
            //F9: stop recording
            KKRecorder.sharedInstance.stopRecording()
            return
        } else if theEvent.keyCode == 109 {
            //F10: save recording
            KKRecorder.sharedInstance.saveRecording()
            return
        }
        
        if let note = keyMap[theEvent.keyCode] {
            let noteToPlay = min(note + octaveOffset * 12,127)
            activeNotesByKeyCode[theEvent.keyCode] = noteToPlay
            if isMonophonic {
                if (activeNotesByKeyCode[lastKey()] != nil){
                    instrument!.stop(noteNumber: MIDINoteNumber(activeNotesByKeyCode[lastKey()]!))
                }
                pushKeyCode(theEvent.keyCode)
            }
            instrument!.play(noteNumber: MIDINoteNumber(noteToPlay),velocity:127)
        }
    }
    
    func killAll() {
        for (_, note) in activeNotesByKeyCode{
            instrument?.stop(noteNumber: MIDINoteNumber(note))
        }
        activeNotesByKeyCode.removeAll()
        keyList.removeAll()
    }
    
    //monophonic
    var keyList = [UInt16]()
    
    func pushKeyCode(_ keyCode: UInt16){
        keyList.append(keyCode)
    }

    func popKeyCode() {
        if keyList.count > 0{
            keyList.removeLast()
        }
    }
    
    func lastKey() -> UInt16 {
        return keyList.count > 0 ? keyList.last! : 0
    }
    
    func dropKey(_ keyCode:UInt16){
        if keyList.isEmpty {
            return
        }
        for i in 0..<keyList.count - 1{
            if keyList[i] == keyCode {
                keyList.remove(at: i)
                break
            }
        }
    }
}


