//
//  KKTabViewController.swift
//  KeyboardKeyboard
//
//  Created by 杨嘉浩 on 16/2/22.
//  Copyright © 2016年 TYKH. All rights reserved.
//

import Cocoa

class KKTabViewController: NSTabViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func tabView(tabView: NSTabView, didSelectTabViewItem tabViewItem: NSTabViewItem?) {
        print(tabViewItem)
    }
    
}
