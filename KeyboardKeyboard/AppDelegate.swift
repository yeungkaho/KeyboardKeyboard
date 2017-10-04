//
//  AppDelegate.swift
//  KeyboardKeyboard
//
//  Created by Yeung Ka Ho on 16/2/19.
//  Copyright © 2016年 TYKH. All rights reserved.
//

import Cocoa
import AudioKit
import SnapKit

class AppDelegate: NSObject, NSApplicationDelegate, NSTabViewDelegate {
    
    static let shared = AppDelegate()
    
    func applicationWillBecomeActive(_ notification: Notification) {
        AudioKit.start()
    }
    
    let tabView = NSTabView()
    var window: NSWindow!
    var controllers: [NSViewController]?
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        
        tabView.delegate = self
        tabView.wantsLayer = true
        tabView.layer?.backgroundColor = nil
        tabView.font = NSFont(name: "Courier", size: 12)!
        

        window = KKWindow(contentRect: NSMakeRect(0, 0, 0, 0), styleMask: [.titled,.closable,.miniaturizable], backing: .buffered, defer: false)
        window?.center()
        window?.title = "KeyboardKeyboard"
        
        window?.contentView?.addSubview(tabView)
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.backgroundColor = nil
        tabView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(window.contentView!)
            make.centerX.equalTo(window.contentView!)
            
        }
        
        let pwmInfo:InstrumentInfo = [("attackDuration","Attack Duration",(0.0,0.5),0.0),
                                      ("decayDuration","Decay Duration",(0.0,1.0),0.0),
                                      ("sustainLevel","Sustain Level",(0.0,1.0),1.0),
                                      ("releaseDuration","Release Duration",(0.0,2.0),0.0),
                                      ("vibratoDepth","Vibrato Depth",(0.0,0.5),0.0),
                                      ("vibratoRate","Vibrato Rate",(0.0,8.0),0.0),
                                      ("pulseWidth","Pulse Width",(0.0,1.0),0.5)]
        
        let pwmInstrument = AKPWMOscillatorBank(pulseWidth: 0.5, attackDuration: 0.0, decayDuration: 0.0, sustainLevel: 1.0, releaseDuration: 0.0, pitchBend: 0.0, vibratoDepth: 0.0, vibratoRate: 0.0)
        
        
        let sawInfo:InstrumentInfo = [("attackDuration","Attack Duration",(0.0,0.5),0.005),
                                      ("decayDuration","Decay Duration",(0.0,1.0),0.0),
                                      ("sustainLevel","Sustain Level",(0.0,1.0),1.0),
                                      ("releaseDuration","Release Duration",(0.0,2.0),0.005),
                                      ("vibratoDepth","Vibrato Depth",(0.0,0.5),0.0),
                                      ("vibratoRate","Vibrato Rate",(0.0,8.0),0.0)]
        
        let sawtoothInstrument = AKOscillatorBank(waveform: AKTable(.sawtooth, count:65536), attackDuration: 0.005, decayDuration: 0.0, sustainLevel: 1.0, releaseDuration: 0.005, pitchBend: 0.0, vibratoDepth: 0.0, vibratoRate: 0.0)
        
        let sineInfo:InstrumentInfo = [("attackDuration","Attack Duration",(0.0,0.5),0.005),
                                      ("decayDuration","Decay Duration",(0.0,1.0),0.0),
                                      ("sustainLevel","Sustain Level",(0.0,1.0),1.0),
                                      ("releaseDuration","Release Duration",(0.0,2.0),0.005),
                                      ("vibratoDepth","Vibrato Depth",(0.0,0.5),0.0),
                                      ("vibratoRate","Vibrato Rate",(0.0,8.0),0.0)]
        let sinewaveInstrument = AKOscillatorBank(waveform: AKTable(.sine), attackDuration: 0.005, decayDuration: 0.0, sustainLevel: 1.0, releaseDuration: 0.005, pitchBend: 0.0, vibratoDepth: 0.0, vibratoRate: 0.0)
        
        
        let triangleInfo:InstrumentInfo = [("attackDuration","Attack Duration",(0.0,0.5),0.005),
                                      ("decayDuration","Decay Duration",(0.0,1.0),0.0),
                                      ("sustainLevel","Sustain Level",(0.0,1.0),1.0),
                                      ("releaseDuration","Release Duration",(0.0,2.0),0.005),
                                      ("vibratoDepth","Vibrato Depth",(0.0,0.5),0.0),
                                      ("vibratoRate","Vibrato Rate",(0.0,8.0),0.0)]
        
        let tritable = AKTable(.triangle, count:65536)
        let triangleInstrument = AKOscillatorBank(waveform: tritable, attackDuration: 0.005, decayDuration: 0.0, sustainLevel: 1.0, releaseDuration: 0.005, pitchBend: 0.0, vibratoDepth: 0.0, vibratoRate: 0.0)
        
        controllers = [
            KKInstrumentViewController(instrument: pwmInstrument, info: pwmInfo, title:"PWM", defaultVolume:0.5),
            KKInstrumentViewController(instrument: sawtoothInstrument, info: sawInfo, title:"Sawtooth", defaultVolume:0.7),
            KKInstrumentViewController(instrument: sinewaveInstrument, info: sineInfo, title:"Sine"),
            KKInstrumentViewController(instrument: triangleInstrument, info: triangleInfo, title:"Triangle")
        ]
        
        let tabViewItems = controllers!.map({ vc in
            return NSTabViewItem(viewController: vc)
        })
        
        for item in tabViewItems {
            tabView.addTabViewItem(item)
        }
        
        window!.makeKeyAndOrderFront(nil)
        resize()
    }
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        resize()
    }
    
    func resize() {
        if let selectedVC = tabView.selectedTabViewItem?.viewController as? KKInstrumentViewController {
            
            let size = selectedVC.slidersSize
            let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
            let contentFrame = window.frameRect(forContentRect: contentRect)
            let toolbarHeight = CGFloat(24)
            let newSize = NSSize(width: contentFrame.size.width, height: contentFrame.size.height + toolbarHeight)
            let heightDelta:CGFloat = newSize.height - window.frame.size.height
            let newOrigin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y - heightDelta)
            let newFrame = NSRect(origin: newOrigin, size: newSize)
            window.setFrame(newFrame, display: true, animate: false)
        }
    }
    
    func chooseInstrument(_ index:Int) {
        tabView.selectTabViewItem(at: index)
//        resize()
    }
}

 
