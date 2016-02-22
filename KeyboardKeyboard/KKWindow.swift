//
//  KKWindow.swift
//  KeyboardKeyboard
//
//  Created by Yeung Ka Ho on 16/2/19.
//  Copyright © 2016年 TYKH. All rights reserved.
//

import Foundation
import Cocoa

class KKWindow: NSWindow {
    override var canBecomeMainWindow: Bool { return true }
    override var canBecomeKeyWindow: Bool { return true }
    override func keyDown(theEvent: NSEvent) {
        KKInstrument.sharedInstance.keyDown(theEvent)
    }
    override func keyUp(theEvent: NSEvent) {
        KKInstrument.sharedInstance.keyUp(theEvent)
    }
}