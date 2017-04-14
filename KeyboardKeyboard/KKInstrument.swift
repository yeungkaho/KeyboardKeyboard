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
    
    var activeNotes = [Int]()
    
    var instrument:AKPolyphonicNode? {
        didSet{
            for (_,note) in activeNotesByKeyCode{
                oldValue!.stop(noteNumber: MIDINoteNumber(note))
            }
            activeNotesByKeyCode.removeAll()
        }
    }
    
    
    var mixer: AKMixer? {
        didSet{
            AudioKit.stop()
            AudioKit.output = mixer
            AudioKit.start()
        }
    }
    
    fileprivate init () {
    }
    
    var activeNotesDescription:String {
        get {
            func toNoteName(_ noteInt:Int)->String {
                return "\(noteInt)"
            }
            return (activeNotes.map(toNoteName).description)
        }
    }
    
    func keyUp(_ theEvent: NSEvent) {
        if keyMap[theEvent.keyCode] == nil {
            return
        }
        
        if let note = activeNotesByKeyCode[theEvent.keyCode] {
            instrument!.stop(noteNumber: MIDINoteNumber(note))
        }
        
        activeNotesByKeyCode.removeValue(forKey: theEvent.keyCode)
    }
    
    func keyDown(_ theEvent: NSEvent) {
        if theEvent.isARepeat || theEvent.modifierFlags.contains(.command){
            //ignore repeats or command key shortcuts
            return
        }
        
        if theEvent.keyCode == 48 {
            //tab
            if (octaveOffset < 12){
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
            for (_, note) in activeNotesByKeyCode{
                instrument?.stop(noteNumber: MIDINoteNumber(note))
            }
            activeNotesByKeyCode.removeAll()
            AudioKit.stop()
            AudioKit.start()
            return
        }
        
        if let note = keyMap[theEvent.keyCode] {
            let noteToPlay = note + octaveOffset * 12
            activeNotesByKeyCode[theEvent.keyCode] = noteToPlay
            instrument!.play(noteNumber: MIDINoteNumber(noteToPlay),velocity:127)
        }
        
        
        
    }
}
