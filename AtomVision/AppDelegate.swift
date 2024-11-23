//
//  AppDelegate.swift
//  AtomVision
//
//  Created by Anvar Madvaliev on 02/07/24.
//

import AppKit
import SwiftUI

@Observable class AppDelegate: NSObject, NSApplicationDelegate {
    static var popover = NSPopover()
    var statusBar: StatusBarController?
    
    var zenState = ZenState.Lazy
    var cronTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        monitor()
        
        for window in NSApplication.shared.windows {
            if window.title == "Preferences" {
                window.orderOut(self)
            }
        }
        Self.popover.contentViewController = NSHostingController(
            rootView: PopoverView(appState: self)
        )
        Self.popover.behavior = .transient
        statusBar = StatusBarController(Self.popover)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        cronTimer?.invalidate()
    }
    
    private func monitor() {
        cronTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { _ in
            if self.zenState != .Focus {
                self.hideApps()
            }
        }
    }
    
    private func hideApps() {
        let apps = NSWorkspace.shared.runningApplications
        
        for app in apps {
            if ["Telegram", "Safari", "iTerm2", "Docker Desktop"].contains(app.localizedName) {
               app.hide()
            }
        }
    }
}

enum ZenState {
    case Focus
    case Break
    case Lazy
}
