//
//  KKInstrument.swift
//  KeyboardKeyboard
//
//  Created by Yeung Ka Ho on 16/2/19.
//  Copyright © 2016年 TYKH. All rights reserved.
//

import Foundation
import AudioKit

class KKInstrument {
    
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

    var instrument:AKPWMSynth!
    
    var activeNotesByKeyCode = Dictionary<UInt16,Int>()
    
    var keyStatus = [UInt16]()
    
    var octaveOffset = 5
    
    var volume:Double {
        set {
            instrument.volume = newValue;
        }
        get {
            return instrument.volume
        }
    }
    
    var pulseWidth:Double {
        set {instrument.pulseWidth = newValue;}
        get {return instrument.pulseWidth}
    }
    
    var decayDuration:Double {
        set {instrument.decayDuration = newValue;}
        get {return instrument.decayDuration}
    }
    
    var attackDuration:Double {
        set {instrument.attackDuration = newValue}
        get {return instrument.attackDuration}
    }
    
    var releaseDuration:Double {
        set {instrument.releaseDuration = newValue}
        get {return instrument.releaseDuration}
    }
    
    var sustainLevel:Double {
        set {instrument.sustainLevel = newValue}
        get {return instrument.sustainLevel}
    }
    
    init () {
        instrument = AKPWMSynth(voiceCount:8)
        instrument.pulseWidth = 0.5
        instrument.decayDuration = 0.0
        instrument.attackDuration = 0.0
        instrument.releaseDuration = 0.1
        instrument.volume = 0.4
        instrument.sustainLevel = 1
        AudioKit.output = instrument
        AudioKit.start()
    }
    
    func keyUp(theEvent: NSEvent) {
        if keyMap[theEvent.keyCode] == nil {
            return
        }
        
        if let note = activeNotesByKeyCode[theEvent.keyCode] {
            instrument.stopNote(note)
        }
        
        activeNotesByKeyCode.removeValueForKey(theEvent.keyCode)
    }
    
    func keyDown(theEvent: NSEvent) {
        if theEvent.ARepeat {
            //ignore repeats
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
        }
        
        if keyMap[theEvent.keyCode] == nil {
            //not specified as an instrumental key
            return
        }
        
        let noteToPlay = keyMap[theEvent.keyCode]! + octaveOffset * 12
        activeNotesByKeyCode[theEvent.keyCode] = noteToPlay
        instrument.playNote(noteToPlay,velocity:127)
        
    }
}