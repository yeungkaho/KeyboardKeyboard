//
//  KKInstrumentViewController.swift
//  KeyboardKeyboard
//
//  Created by KaHo Yeung on 25/9/2017.
//  Copyright © 2017 TYKH. All rights reserved.
//

import Cocoa
import AudioKit
import AudioKitUI

typealias PropertyRange = (min:Double,max:Double)
typealias InstrumentPropertyInfo = (name:String,displayName:String,range:PropertyRange,defaultValue:Double)
typealias InstrumentInfo = [InstrumentPropertyInfo]

class KKInstrumentViewController: NSViewController, AKKeyboardDelegate{
    
    let instrument: AKPolyphonicNode
    
    let instrumentInfo : InstrumentInfo
    let mixer = AKMixer()
    
    var lpf: AKLowPassFilter?
//    var settingViews = [NSView]()
    
    private var propertySettingStackView: NSStackView?
//
//    var volumeSlider : NSSlider!
    
    init(instrument: AKPolyphonicNode, info:InstrumentInfo) {
        self.instrument = instrument
        self.instrumentInfo = info
        
        lpf = AKLowPassFilter(instrument)
        lpf?.cutoffFrequency = 22050
        mixer.volume = 1.0
        mixer.connect(to:lpf!)
        KKInstrument.sharedInstance.mixer.connect(to:mixer)
        super.init(nibName: nil, bundle: nil)!
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = NSView(frame: NSMakeRect(0,0,600,600))
        view.wantsLayer = true
        view.layer?.borderWidth = 2
        view.layer?.borderColor = NSColor.red.cgColor
        self.view = view
    }
    
    override func viewDidLoad() {
        var views = [NSView]()
        propertySettingStackView =  NSStackView(views: views)
        
        
        
    }
    
    override func viewDidAppear() {
        AudioKit.stop()
        AudioKit.output = instrument
        AudioKit.start()
    }
    
    func KKPropertyChanged(_ name: String, value: Double) {
        
        if let _ = instrument.value(forKey: name)  {
            instrument.setValue(value, forKey: name)
            //            print("\(name):\(value)")
        }
    }
    
    func noteOn(note: MIDINoteNumber) {
        instrument.play(noteNumber: note, velocity: 127)
        
    }
    
    func noteOff(note: MIDINoteNumber) {
        instrument.stop(noteNumber: note)
    }
    
    
    
    
    
}

