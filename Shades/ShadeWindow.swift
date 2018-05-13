//
//  ShadeWindow.swift
//  Shades
//
//  Created by Patrick William Thomson on 4/30/18.
//  Copyright © 2018 Patrick Thomson. All rights reserved.
//

import Cocoa

class ShadeWindow: NSWindow {
    static let defaultContentRect = NSRect(x: 800, y: 800, width: 400, height: 400)
    static let defaultColor = NSColor.blue.withAlphaComponent(0.4)
    private let kConfiguringMask : NSWindow.StyleMask = [.closable, .resizable]
    private let kStandardMask : NSWindow.StyleMask = .borderless
    private var closeWindowIconView: CloseWindowIconView?
    var closeWindowDelegate: CloseWindowDelegate!
    
    override var backgroundColor: NSColor! {
        didSet {
            self.alphaValue = self.backgroundColor.alphaComponent
        }
    }
    
    var configuring : Bool = false {
        didSet {
            self.ignoresMouseEvents = !configuring
            self.styleMask = configuring ? kConfiguringMask : kStandardMask
            
            if self.closeWindowIconView != nil && !configuring {
                self.closeWindowIconView!.removeFromSuperview()
                self.closeWindowIconView = nil
            }
            
            initializeCloseWindowView()
        }
    }
    
    func initializeCloseWindowView() {
        if configuring && closeWindowIconView == nil {
            closeWindowIconView = CloseWindowIconView.addCloseWindowIconView(inView: self.contentView!, forWindow: self, delegate: closeWindowDelegate)
        }
    }
    
    init(withRect contentRect: NSRect, withBackgroundColor backgroundColor: NSColor, withDelegate closeWindowDelegate: CloseWindowDelegate) {
        super.init(contentRect: contentRect,
                   styleMask: kConfiguringMask,
                   backing: NSWindow.BackingStoreType.buffered,
                   defer: false)
        self.backgroundColor = backgroundColor
        
        self.closeWindowDelegate = closeWindowDelegate
        self.configuring = true
        self.level = NSWindow.Level.floating
        self.isMovableByWindowBackground = true
    }
    
    func toggleConfiguring() {
        self.configuring = !self.configuring
    }

}
