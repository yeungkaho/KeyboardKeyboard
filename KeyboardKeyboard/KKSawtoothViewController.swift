//
//  KKSawtoothViewController.swift
//  KeyboardKeyboard
//
//  Created by 杨嘉浩 on 16/2/22.
//  Copyright © 2016年 TYKH. All rights reserved.
//

import Cocoa
import AudioKit


class KKSawtoothViewController: NSViewController {
    
    let instrument = AKOscillatorBank(waveform: AKTable(.sawtooth))
    
    let mixer = AKMixer()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        instrument.decayDuration = 0.0
        instrument.attackDuration = 0.0
        instrument.releaseDuration = 0.0
        instrument.sustainLevel = 1
        mixer.volume = 0.5
        mixer.connect(instrument)
    }
    
    override func viewWillAppear() {
        KKInstrument.sharedInstance.instrument = instrument
        KKInstrument.sharedInstance.mixer = mixer
        
    }

    @IBOutlet weak var volumeLabel: NSTextField!
    @IBAction func volumeSliderSlid(_ sender: NSSlider) {
        mixer.volume = sender.doubleValue
        volumeLabel.stringValue = String(format:"volume\n%.0f%%",sender.doubleValue*100)
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
