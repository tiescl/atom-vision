//
//  AppDelegate.swift
//  AtomVision
//
//  Created by Anvar Madvaliev on 02/07/24.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    static var popover = NSPopover()
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        for window in NSApplication.shared.windows {
            if window.title == "Preferences" {
                window.orderOut(self)
            }
        }
        
        Self.popover.contentViewController = NSHostingController(rootView: PopoverView())
        Self.popover.behavior = .transient
        
        statusBar = StatusBarController(Self.popover)
    }
}
