//
//  PreferencesDetail.swift
//  AtomVision
//
//  Created by Anvar Madvaliev on 02/07/24.
//

import SwiftUI

struct General: View {
    
    @AppStorage("timerDurationText") private var timerDurationText: String = "30"
    
    @State private var timerDurationSlider: Double = 30.0
    
    @State private var launchOnStart: Bool = false
    @State private var automaticUpdates: Bool = true
    
    var body: some View {
        
        Form {
            
            VStack {
                
                versionSection
                
                Divider()
                    .padding(.top, -8)
                
                VStack {
                    
                    TimerDurationControls(
                        timerDurationText: $timerDurationText,
                        timerDurationSlider: $timerDurationSlider
                    )
                    
                    Divider()
                        .padding(.bottom, 20)
                        .padding(.top)
                    
                    defaultToggles
                    
                }
                .padding(.horizontal)
                .padding(.top, 5)
                .toggleStyle(.switch)
                
            }
            
            Spacer()
        }
        
    }
    
    var versionSection: some View {
        
        HStack {
            
            Text("Current version")
            
            Spacer()
            
            Text("0.0.1")
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .foregroundColor(.secondary)
        .background(.gray.opacity(0.1))
        
    }
    
    var defaultToggles: some View {
        
        Group {
            
            Toggle(isOn: $launchOnStart) {
                
                HStack {
                    
                    Text("Launch on start")
                    Spacer()
                    
                }
                
            }
            
            Toggle(isOn: $automaticUpdates) {
                
                HStack {
                    
                    Text("Automatic updates")
                    Spacer()
                    
                }
                
            }
            
        }
        
    }
    
}

struct TimerDurationControls: View {
    
    @Binding var timerDurationText: String
    @Binding var timerDurationSlider: Double
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        
        textFieldMinutes
        
        sliderMinutes
        
    }
    
    var textFieldMinutes: some View {
        
        TextField(text: $timerDurationText) {
            
            HStack {
                
                Text("Timer Duration")
                    .padding(.trailing, 325)
                
            }
            
        }
        .padding(.bottom, 5)
        .textFieldStyle(.roundedBorder)
        .focused($isTextFieldFocused)
        .onChange(of: timerDurationText) { _, newValue in
            
            if let value = Double(newValue), value >= 1, value <= 60 {
                
                timerDurationSlider = value;
                
            }
            
        }
        .onChange(of: isTextFieldFocused) { _, isFocused in
            
            if !isFocused {
                
                if let value = Double(timerDurationText) {
                    
                    let roundedValue = round(value);
                    
                    let adjustedValue: Double;
                    
                    if roundedValue < 1 {
                        
                        adjustedValue = 1;
                        
                    } else if roundedValue > 60 {
                        
                        adjustedValue = 60;
                        
                    } else {
                        
                        adjustedValue = roundedValue;
                        
                    }
                    
                    timerDurationText = "\(Int(adjustedValue))"
                    
                    timerDurationSlider = adjustedValue
                    
                } else {
                    
                    timerDurationText = "\(Int(timerDurationSlider))"
                    
                }
                
            }
        }
        
    }
    
    var sliderMinutes: some View {
        
        Slider(
            value: $timerDurationSlider,
            in: 1...60
        )
        .onChange(of: timerDurationSlider) { _, newValue in
            
            let roundedValue = round(newValue)
            timerDurationText = "\(Int(roundedValue))"
            timerDurationSlider = roundedValue
            
        }
        .onAppear {
            timerDurationSlider = Double(timerDurationText) ?? 30.0
        }
        
    }
    
}

#Preview {
    General()
}
