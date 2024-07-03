//
//  AtomVisionApp.swift
//  AtomVision
//
//  Created by Anvar Madvaliev on 02/07/24.
//

import SwiftUI

@main
struct AtomVisionApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        
        Window("Preferences", id: "preferences") {
            Preferences()
        }
        
        WindowGroup {
            EmptyView()
        }
    }
}
