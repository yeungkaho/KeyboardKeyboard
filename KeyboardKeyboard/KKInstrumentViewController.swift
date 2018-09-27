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
import SnapKit

typealias PropertyRange = (min:Double,max:Double)
typealias InstrumentPropertyInfo = (name:String,displayName:String,range:PropertyRange,defaultValue:Double)
typealias InstrumentInfo = [InstrumentPropertyInfo]

fileprivate let sliderColors:[NSColor] = [.red,.green,.blue,.yellow,.orange,.purple]

let sliderWidth:CGFloat = 300.0
let sliderHeight:CGFloat = 40.0

class KKInstrumentViewController: NSViewController, AKKeyboardDelegate{
    
    let instrument: AKPolyphonicNode
    
    let instrumentInfo : InstrumentInfo
    let mixer = AKMixer()
    
    var lpf: AKLowPassFilter?
    
    var slidersHeight:CGFloat {
        return CGFloat(instrumentInfo.count+2) * sliderHeight
    }
    
    var slidersSize:CGSize {
        return CGSize(width: sliderWidth, height: slidersHeight + CGFloat(0))
    }
    
    private let defaultVolume: Double
    
    private var propertySettingStackView: NSStackView?
//
//    var volumeSlider : NSSlider!
    
    init(instrument: AKPolyphonicNode, info:InstrumentInfo, title:String, defaultVolume:Double = 1.0) {
        self.instrument = instrument
        self.instrumentInfo = info
        

//        let ins = instrument
        
        lpf = AKLowPassFilter(instrument)
        lpf?.cutoffFrequency = 22050
        self.defaultVolume = defaultVolume
        mixer.volume = defaultVolume
        lpf!.connect(to:mixer)
        mixer.connect(to:KKInstrument.sharedInstance.mixer)
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = NSView(frame: NSMakeRect(0,0,sliderWidth,slidersHeight))
//        view.wantsLayer = true
//        view.layer?.backgroundColor = NSColor.green.cgColor
//        view.layer?.borderWidth = 2
//        view.layer?.borderColor = NSColor.red.cgColor
        self.view = view
    }
    
    override func viewDidLoad() {
        
        for i in instrumentInfo.indices {
            let info = instrumentInfo[i]
            let slider = AKSlider(property: info.displayName, value: info.defaultValue, range: info.range.min...info.range.max, color: sliderColors[i % sliderColors.count], frame: CGRect(x: 0, y: slidersHeight - sliderHeight - CGFloat(i+2)*sliderHeight, width: sliderWidth, height: sliderHeight), callback: { value in
                self.instrument.setValue(value, forKey: info.name)
            })
            //            views.append(slider)
//            slider.showsValueBubble = true
//            slider.bgColor = .yellow
//            slider.wantsLayer = true
//            slider.layer?.borderWidth = 2
//            slider.layer?.borderColor = NSColor.green.cgColor
            slider.fontSize = 12
            slider.textColor = .darkGray
            view.addSubview(slider)
            
            slider.snp.makeConstraints({ (make) in
                make.left.right.equalTo(view)
            })
        }
        
        let lpfSlider = AKSlider(property: "Cutoff Frequency", value: 22050.0, range: 0.0...22050.0, color: .cyan, frame: CGRect(x: 0, y:  CGFloat(instrumentInfo.count)*sliderHeight, width: sliderWidth, height: sliderHeight)) { value in
            self.lpf!.cutoffFrequency = value
        }
        lpfSlider.textColor = .darkGray
        lpfSlider.fontSize = 12
        view.addSubview(lpfSlider)
        lpfSlider.snp.makeConstraints({ (make) in
            make.left.right.equalTo(view)
        })
        let volumeSlider = AKSlider(property: "Volume", value: defaultVolume, range: 0.0...1.0, color: .cyan, frame: CGRect(x: 0, y: CGFloat(instrumentInfo.count+1)*sliderHeight, width: sliderWidth, height: sliderHeight)) { value in
            self.mixer.volume = value
        }
        volumeSlider.textColor = .darkGray
        volumeSlider.fontSize = 12
        view.addSubview(volumeSlider)
        volumeSlider.snp.makeConstraints({ (make) in
            make.left.right.equalTo(view)
        })
//        propertySettingStackView =  NSStackView(views: views)
//        view.addSubview(propertySettingStackView!)
        
        
    }
    
//    override func viewDidAppear() {
//        AudioKit.stop()
//        AudioKit.start()
//    }
    
    override func viewWillAppear() {
        KKInstrument.sharedInstance.instrument = instrument
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

