//
//  CloseWindowDelegate.swift
//  Shades
//
//  Created by Warren Henning on 5/12/18.
//  Copyright © 2018 Patrick Thomson. All rights reserved.
//

import Foundation

protocol CloseWindowDelegate {
    func closeWindow(_ inView: CloseWindowIconView, windowDidClose window: ShadeWindow)
}
