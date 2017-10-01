//
//  main.swift
//  KeyboardKeyboard
//
//  Created by KaHo Yeung on 26/9/2017.
//  Copyright © 2017 TYKH. All rights reserved.
//

import Foundation
import Cocoa

let delegate = AppDelegate() //alloc main app's delegate class
NSApplication.shared().delegate = delegate //set as app's delegate

// Old versions:
// NSApplicationMain(C_ARGC, C_ARGV)
NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)  //start of run loop
