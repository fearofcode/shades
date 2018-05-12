//
//  CloseWindowIconView.swift
//  Shades
//
//  Created by Warren Henning on 5/12/18.
//  Copyright © 2018 Patrick Thomson. All rights reserved.
//

import Cocoa

class CloseWindowIconView: NSView {
    static let width: CGFloat = 32
    static let height: CGFloat = 32
    static let x: CGFloat = 16
    static let y: CGFloat = 16
    
    var trackingArea: NSTrackingArea?
    var delegate: CloseWindowDelegate!
    var shadeWindow: ShadeWindow!
    var previousCursor: NSCursor?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.red.setFill()
        
        let rect = CGRect(
            x: 0,
            y: 0,
            width: CloseWindowIconView.width,
            height: CloseWindowIconView.height
        )
        
        rect.fill()
    }
    
    // TODO should not draw when not in configuration mode
    
    override func mouseDown(with event: NSEvent) {
        previousCursor?.set()
        delegate.closeWindow(self, windowDidClose: shadeWindow)
    }
    
    override func mouseEntered(with event: NSEvent) {
        // store user's current cursor in case default arrow cursor not being used due to accessibility reasons
        previousCursor = NSCursor.current
        
        NSCursor.pointingHand.set()
    }
    
    override func mouseExited(with event: NSEvent) {
        previousCursor?.set()
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if trackingArea == nil {
            trackingArea = NSTrackingArea(
                rect: visibleRect,
                options: [.activeAlways, .mouseEnteredAndExited],
                owner: self,
                userInfo: nil
            )
        }
        
        if !trackingAreas.contains(trackingArea!) {
            addTrackingArea(trackingArea!)
        }
    }
    
    class func addCloseWindowIconView(inView view: NSView, forWindow window: ShadeWindow, delegate: CloseWindowDelegate) {
        let frame = NSRect(
            x: CloseWindowIconView.x,
            y: view.bounds.height - (CloseWindowIconView.y + CloseWindowIconView.height),
            width: CloseWindowIconView.width,
            height: CloseWindowIconView.height
        )
        
        let closeWindowView = CloseWindowIconView(frame: frame)
        closeWindowView.shadeWindow = window
        closeWindowView.delegate = delegate
        // TODO consider making a separate rect view and have window itself not be transparent to allow view
        // to not share opacity of window
        
        view.addSubview(closeWindowView)
    }
}
