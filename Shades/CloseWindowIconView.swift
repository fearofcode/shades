//
//  CloseWindowIconView.swift
//  Shades
//
//  Created by Warren Henning on 5/12/18.
//  Copyright © 2018 Patrick Thomson. All rights reserved.
//

import Cocoa

class CloseWindowIconView: NSView {
    static let width: CGFloat = 24
    static let height: CGFloat = 24
    static let x: CGFloat = 8
    static let y: CGFloat = 8
    
    var trackingArea: NSTrackingArea?
    var delegate: CloseWindowDelegate!
    var shadeWindow: ShadeWindow!
    var previousCursor: NSCursor?
    
    override func draw(_ dirtyRect: NSRect) {
        let strokeWidth: CGFloat = 2
        let inset: CGFloat = 6
        
        super.draw(dirtyRect)
        NSColor.white.setStroke()
        NSColor.black.setFill()
        
        let rect = dirtyRect.insetBy(dx: strokeWidth, dy: strokeWidth)
        
        let path = NSBezierPath(ovalIn: rect)
        path.lineWidth = strokeWidth
        path.stroke()
        path.fill()
 
        let withinCircle = rect.insetBy(dx: inset, dy: inset)
        
        // up and to the right
        let line = NSBezierPath()
        line.lineWidth = strokeWidth
        line.lineCapStyle = .roundLineCapStyle
        let start = NSPoint(x: withinCircle.minX, y: withinCircle.minY)
        line.move(to: start)
        line.line(to: NSPoint(x: withinCircle.maxX, y: withinCircle.maxY))
        line.stroke()
        
        // down and to the right
        let line2 = NSBezierPath()
        line2.lineWidth = strokeWidth
        line2.lineCapStyle = .roundLineCapStyle
        line2.move(to: NSPoint(x: withinCircle.minX, y: withinCircle.maxY))
        line2.line(to: NSPoint(x: withinCircle.maxX, y: withinCircle.minY))
        line2.stroke()
    }
    
    override func mouseDown(with event: NSEvent) {
        toolTip = nil
        previousCursor?.set()
        delegate.closeWindow(self, windowDidClose: shadeWindow)
    }
    
    override func mouseEntered(with event: NSEvent) {
        // store user's current cursor in case default arrow cursor not being used due to accessibility reasons
        previousCursor = NSCursor.current
        toolTip = "Close this window"
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
            x: x,
            y: view.bounds.height - (y + height),
            width: width,
            height: height
        )
        
        let closeWindowView = CloseWindowIconView(frame: frame)
        closeWindowView.shadeWindow = window
        closeWindowView.delegate = delegate
        closeWindowView.shadow = NSShadow()
        closeWindowView.wantsLayer = true
        closeWindowView.layer?.shadowOpacity = 1.0
        closeWindowView.layer?.shadowColor = NSColor.black.cgColor
        closeWindowView.layer?.shadowOffset = NSMakeSize(2, -2)
        closeWindowView.layer?.shadowRadius = 2
        
        view.addSubview(closeWindowView)
        
        // pin to top left. setting topAnchor and leadingAnchor caused the view to not be vertically resizable
        closeWindowView.autoresizingMask = [.maxXMargin, .minYMargin]
    }
}
