//
//  AppDelegate.swift
//  Shades
//
//  Created by Patrick Thomson on 4/30/18.
//  Copyright © 2018 Patrick Thomson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private let kShadeColorKey = "shadeColor"
    private let kWindowFramesKey = "windowFrames"

    @IBOutlet weak var statusMenu: NSMenu!

    var statusItem: NSStatusItem!
    var shadeWindows: [ShadeWindow] = []
    var shadeColor = ShadeWindow.defaultColor

    var colorPanel: NSColorPanel?
    
    @objc var configuring: Bool = true
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard statusMenu != nil else {
            fatalError("IBOutlets not connected")
        }
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button!.imageScaling = .scaleProportionallyDown
        statusItem.button!.image = NSImage.init(named:NSImage.Name("sunglasses"))
        statusItem.menu = statusMenu

        self.configuring = true

        // load shade color if one was previously set
        let defaults = UserDefaults.standard
        if let colorData = defaults.data(forKey: kShadeColorKey) {
            shadeColor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! NSColor
        }

        // load windows if any previously saved
        if let frameData = defaults.data(forKey: kWindowFramesKey) {
            let frames = NSKeyedUnarchiver.unarchiveObject(with: frameData) as! [NSRect]

            for frame in frames {
                let _ = addWindow(withRect: frame)
            }
        }
    }
    
    @objc func setShadeColor(_ sender:NSColorPanel) {
        shadeColor = sender.color

        for shade in shadeWindows {
            shade.backgroundColor = shadeColor
        }
    }

    func addWindow(withRect rect: NSRect) -> ShadeWindow {
        let newShade = ShadeWindow(withRect: rect, withBackgroundColor: shadeColor)
        newShade.delegate = self
        shadeWindows.append(newShade)
        
        newShade.makeKeyAndOrderFront(self)
        
        return newShade
    }
    
    func configureAllWindows() {
        self.configuring = true
        
        for shade in shadeWindows {
            shade.configuring = true
        }
    }
    
    @IBAction func addDefaultSizedRect(_ sender:NSMenuItem) {
        configureAllWindows()
        
        let window = addWindow(withRect: ShadeWindow.defaultContentRect)

        window.configuring = true
    }
    
    @IBAction func configureShades(_ sender:NSMenuItem) {
        for shade in shadeWindows {
            shade.orderFront(self)
            shade.toggleConfiguring()
        }
    }

    @IBAction func showColorPicker(_ sender:NSMenuItem) {
        configureAllWindows()
        
        if colorPanel == nil {
            colorPanel = NSColorPanel.shared
            colorPanel!.setTarget(self)
            colorPanel!.showsAlpha = true
            colorPanel!.setAction(#selector(AppDelegate.setShadeColor))
            colorPanel!.color = shadeColor
        }
        colorPanel!.makeKeyAndOrderFront(self)
    }

    func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? ShadeWindow {
            if let index = shadeWindows.index(of: window) {
                shadeWindows.remove(at: index)
            }
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        let defaults = UserDefaults.standard

        // save the shade color
        let colorData = NSKeyedArchiver.archivedData(withRootObject: shadeColor)
        defaults.set(colorData, forKey: kShadeColorKey)

        // save window frames
        let frames = shadeWindows.map { $0.frame }
        let frameData = NSKeyedArchiver.archivedData(withRootObject: frames)
        defaults.set(frameData, forKey: kWindowFramesKey)
    }
}

