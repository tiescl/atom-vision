//
//  PreferencesWindowController.swift
//  AtomVision
//
//  Created by Anvar Madvaliev on 03/07/24.
//

import AppKit
import SwiftUI

class PreferencesController: NSWindowController, NSWindowDelegate {
    
    static let shared = PreferencesController()
    
    private var newWindow: NSWindow?
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func showWindow() {
        
        NSApplication.shared.activate()
        
        if let existingWindow = NSApplication.shared.windows.first(where: { $0.title == "AtomVision Preferences" }) {
            
            existingWindow.makeKeyAndOrderFront(self)
            
            return;
            
        } else {
            
            createNewWindow(controller: self)
            
        }
        
    }
    
    private func createNewWindow(controller: PreferencesController) {
        
        let window = NSWindow(
            contentRect: NSRect(x: 400, y: 400, width: 680, height: 350),
            styleMask: [.closable, .miniaturizable, .fullSizeContentView, .titled],
            backing: .buffered,
            defer: false
        )
        
        window.delegate = controller
        window.isReleasedWhenClosed = false;
        window.title = "AtomVision Preferences"
        window.contentView = NSHostingView(rootView: Preferences())
        window.makeKeyAndOrderFront(controller);
        
        newWindow = window;
        
    }
    
    func windowShouldClose(_ window: NSWindow) -> Bool {
        return true;
    }
    
}
