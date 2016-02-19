//
//  ViewController.swift
//  KeyboardKeyboard
//
//  Created by Yeung Ka Ho on 16/2/19.
//  Copyright © 2016年 TYKH. All rights reserved.
//

import Cocoa
import AudioKit


class ViewController: NSViewController {
    
    let instrument = KKInstrument()
    
    override var acceptsFirstResponder: Bool { return true }

    override func keyUp(theEvent: NSEvent) {
        instrument.keyUp(theEvent)
    }
    
    override func keyDown(theEvent: NSEvent) {
        instrument.keyDown(theEvent)
    }

    @IBOutlet weak var volumeLabel: NSTextField!
    @IBAction func volumeSliderSlid(sender: NSSlider) {
        instrument.volume = sender.doubleValue
        volumeLabel.stringValue = String(format:"volume\n%.0f%%",sender.doubleValue*100)
    }
    
    @IBOutlet weak var pulseWidthLabel: NSTextField!
    @IBAction func pulseWidthSliderSlid(sender: NSSlider) {
        instrument.pulseWidth = sender.doubleValue
        pulseWidthLabel.stringValue = String(format:"pulseWidth:%.6f",sender.doubleValue)
    }
    
    @IBOutlet weak var attackDurationLabel: NSTextField!
    @IBAction func attackDurationSliderSlid(sender: NSSlider) {
        instrument.attackDuration = sender.doubleValue
        attackDurationLabel.stringValue = String(format:"attackDuration:%.6f",sender.doubleValue)

    }
    
    @IBOutlet weak var decayDurationLabel: NSTextField!
    @IBAction func decayDurationSliderSlid(sender: NSSlider) {
        instrument.decayDuration = sender.doubleValue
        decayDurationLabel.stringValue = String(format:"decayDuration:%.6f",sender.doubleValue)
    }
    
    @IBOutlet weak var releaseDurationLabel: NSTextField!
    @IBAction func releaseDurationSliderSlid(sender: NSSlider) {
        instrument.releaseDuration = sender.doubleValue
        releaseDurationLabel.stringValue = String(format:"releaseDuration:%.6f",sender.doubleValue)
    }
    
    @IBOutlet weak var sustainLevelLabel: NSTextField!
    @IBAction func sustainLevelSliderSlid(sender: NSSlider) {
        instrument.sustainLevel = sender.doubleValue
        sustainLevelLabel.stringValue = String(format:"sustainLevel:%.6f",sender.doubleValue)
    }
}

