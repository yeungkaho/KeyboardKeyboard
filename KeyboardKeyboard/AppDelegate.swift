//
//  AppDelegate.swift
//  KeyboardKeyboard
//
//  Created by Yeung Ka Ho on 16/2/19.
//  Copyright © 2016年 TYKH. All rights reserved.
//

import Cocoa
import AudioKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillBecomeActive(_ notification: Notification) {
        AudioKit.start()
    }
}

 
