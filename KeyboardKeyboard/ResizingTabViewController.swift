//
//  ResizingTabViewController.swift
//  KeyboardKeyboard
//
//  Created by KaHo Yeung on 26/9/2017.
//  Copyright © 2017 TYKH. All rights reserved.
//

import AppKit

class ResizingTabViewController: NSTabViewController {
    
    private lazy var tabViewSizes: [NSTabViewItem: NSSize] = [:]
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)
        
        if let tabViewItem = tabViewItem {
            resizeWindowToFit(tabViewItem:tabViewItem)
        }
    }
    
    override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, willSelect: tabViewItem)
        
        // Cache the size of the tab view.
        if let tabViewItem = tabViewItem, let size = tabViewItem.view?.frame.size {
            tabViewSizes[tabViewItem] = size
        }
    }
    
    /// Resizes the window so that it fits the content of the tab.
    func resizeWindowToFit() {
        let tabViewItem = tabViewItems[selectedTabViewItemIndex]
        guard let size = tabViewSizes[tabViewItem], let window = view.window else {
            return
        }
        
        let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let contentFrame = window.frameRect(forContentRect: contentRect)
        let toolbarHeight = CGFloat(24)
        let newSize = NSSize(width: contentFrame.size.width, height: contentFrame.size.height + toolbarHeight)
        let heightDelta = newSize.height - window.frame.size.height
        let newOrigin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y - heightDelta)
        let newFrame = NSRect(origin: newOrigin, size: newSize)
        window.setFrame(newFrame, display: false, animate: true)
    }
    
    func resizeWindowToFit(tabViewItem:NSTabViewItem ) {
        guard let size = tabViewSizes[tabViewItem], let window = view.window else {
            return
        }
        
        let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let contentFrame = window.frameRect(forContentRect: contentRect)
        let toolbarHeight = CGFloat(24)
        let newSize = NSSize(width: contentFrame.size.width, height: contentFrame.size.height + toolbarHeight)
        let newOrigin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y)
        let newFrame = NSRect(origin: newOrigin, size: newSize)
        window.setFrame(newFrame, display: false, animate: true)
    }
    
}

