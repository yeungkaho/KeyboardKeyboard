//
//  AppDelegate.swift
//  KeyboardKeyboard
//
//  Created by Yeung Ka Ho on 16/2/19.
//  Copyright © 2016年 TYKH. All rights reserved.
//

import Cocoa
import AudioKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillBecomeActive(_ notification: Notification) {
        AudioKit.start()
    }
    
    
    
    var newWindow: NSWindow?
    var tabViewController: ResizingTabViewController?
    var controllers: [KKInstrumentViewController]?
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        newWindow = KKWindow(contentRect: NSMakeRect(10, 10, 800, 800), styleMask: [.titled,.closable,.miniaturizable], backing: .buffered, defer: false)
        newWindow?.center()
        tabViewController = ResizingTabViewController()
        controllers = [KKInstrumentViewController(instrument: AKOscillatorBank(), info: [])
        ,KKInstrumentViewController(instrument: AKOscillatorBank(), info: [])]
        
        
        
        let tabViewItems = controllers!.map({ vc in
            return NSTabViewItem(viewController: vc)
        })
        for item in tabViewItems {
            tabViewController?.addTabViewItem(item)
        }
        let content = newWindow!.contentView! as NSView
        let view = tabViewController!.view
        content.addSubview(view)
        
        newWindow!.makeKeyAndOrderFront(nil)
    }
}

 
