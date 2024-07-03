//
//  PreferencesView.swift
//  AtomVision
//
//  Created by Anvar Madvaliev on 02/07/24.
//

import SwiftUI

struct Preferences: View {
    @State private var selection: String?
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                
                List(selection: $selection) {
                    
                    NavigationLink("General", value: "general")
                    NavigationLink("Appearance", value: "appearance")
                    
                }
                .background(.ultraThinMaterial.opacity(0.1))
                .navigationSplitViewColumnWidth(min: 180, ideal: 180, max: 180)
                
            }, detail: {
                
                if selection == "general" {
                    General()
                } else {
                    Appearance()
                }
                
            }
        )
        .onAppear {
            
            selection = "general"
            
        }
    }
}
