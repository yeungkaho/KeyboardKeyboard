//
//  KKTriangleViewController.swift
//  KeyboardKeyboard
//
//  Created by 杨嘉浩 on 16/2/23.
//  Copyright © 2016年 TYKH. All rights reserved.
//

import Cocoa
import AudioKit
import AudioKitUI


class KKTriangleViewController: NSViewController {
    let waveform = AKTable(.triangle)
    let instrument = AKOscillatorBank(waveform: AKTable(.positiveTriangle))
    
    let mixer = AKMixer()
    
    var lpf: AKLowPassFilter?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        instrument.decayDuration = 0.0
        instrument.attackDuration = 0.005
        instrument.releaseDuration = 0.005
        instrument.sustainLevel = 1
        
        instrument.vibratoDepth = 0
        instrument.vibratoRate = 0
        lpf = AKLowPassFilter(instrument)
        lpf?.cutoffFrequency = 22050
        mixer.volume = 1.0
        mixer.connect(lpf!)
        KKInstrument.sharedInstance.mixer.connect(mixer)

    }
    
    override func viewDidLoad() {
        let graph = AKOutputWaveformPlot.createView()
        graph.frame.origin = CGPoint.zero
        view.addSubview(graph)
        
        let v = AKADSRView(frame:CGRect(x: 0, y: 0, width: view.frame.width, height: 150)) { (a, d, s, r) in
            print("a:\(a), d:\(d), s:\(s), r:\(r)")
            self.instrument.setValue(a,forKey: "attackDuration")// as! Double =
            self.instrument.decayDuration = d
            self.instrument.sustainLevel = s
            self.instrument.releaseDuration = r
        }
        v.attackDuration = 0.005
        v.releaseDuration = 0.005
        v.sustainLevel = 1
        v.decayDuration = 0.0
        
        view.addSubview(v)
        
//        AKSlider(property: "Attack", value: 0, range: 0.0...1.0, taper: <#T##Double#>, format: <#T##String#>, color: <#T##AKColor#>, frame: <#T##CGRect#>, callback: <#T##(Double) -> Void#>)
    }
    
    override func viewWillAppear() {
        KKInstrument.sharedInstance.instrument = instrument
        
    }
    override func viewDidAppear() {
        
    }
    
    @IBOutlet weak var volumeLabel: NSTextField!
    @IBAction func volumeSliderSlid(_ sender: NSSlider) {
        mixer.volume = sender.doubleValue
        volumeLabel.stringValue = String(format:"volume\n%.0f%%",sender.doubleValue*100)
    }
    
    @IBOutlet weak var lpfLabel: NSTextField!
    @IBAction func lpfSliderSlid(_ sender: NSSlider) {
        let freq = pow(M_E, sender.doubleValue)
        lpf?.cutoffFrequency = freq
        if sender.doubleValue == sender.maxValue {
            lpfLabel.stringValue = String(format:"LPF\n-")
        } else {
            lpfLabel.stringValue = String(format:"LPF\n%.0f",freq)
        }
    }
    
    @IBOutlet weak var attackDurationLabel: NSTextField!
    @IBAction func attackDurationSliderSlid(_ sender: NSSlider) {
        instrument.attackDuration = sender.doubleValue
        attackDurationLabel.stringValue = String(format:"attackDuration:%.6f",sender.doubleValue)
        
    }
    
    @IBOutlet weak var decayDurationLabel: NSTextField!
    @IBAction func decayDurationSliderSlid(_ sender: NSSlider) {
        instrument.decayDuration = sender.doubleValue
        decayDurationLabel.stringValue = String(format:"decayDuration:%.6f",sender.doubleValue)
    }
    
    @IBOutlet weak var releaseDurationLabel: NSTextField!
    @IBAction func releaseDurationSliderSlid(_ sender: NSSlider) {
        instrument.releaseDuration = sender.doubleValue
        releaseDurationLabel.stringValue = String(format:"releaseDuration:%.6f",sender.doubleValue)
    }
    
    @IBOutlet weak var sustainLevelLabel: NSTextField!
    @IBAction func sustainLevelSliderSlid(_ sender: NSSlider) {
        instrument.sustainLevel = sender.doubleValue
        sustainLevelLabel.stringValue = String(format:"sustainLevel:%.6f",sender.doubleValue)
    }
}
