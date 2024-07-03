//
//  PopoverView.swift
//  AtomVision
//
//  Created by Anvar Madvaliev on 02/07/24.
//

import SwiftUI

struct PopoverView: View {
    @Environment(\.openWindow) private var openWindow
    
    @AppStorage("timerDurationText") private var timerDurationText: String = "30"
    @AppStorage("timerColor") private var timerColorHex: String = Color.white.toHex() ?? "FFFFFF"
    
    @State private var startTime: Date = Date();
    @State private var timeRemaining: Double = 0.0;
    @State private var timerIsRunning: Bool = false;
    
    var time: Double {
        return Double(timerDurationText) ?? 30
    }
    
    let audioManager = AudioManager()
    
    var body: some View {
        VStack {
            
            timer
            
            timeControlButtons
            
            Divider()
            
            utilButtons
            
        }
        .onChange(of: timerIsRunning) {
            if timerIsRunning {
                startTimer()
            }
        }
        
    }
    
    var timer: some View {
        
        Group {
            
            if timeRemaining <= 0.0 {
                
                Text("0:00")
                
            } else {
                
                Text(startTime.addingTimeInterval(TimeInterval(time * 60 + 1)), style: .timer)
                
            }
            
        }
        .font(.system(size: 70))
        .padding(.top, 7)
        .padding(.bottom, 7)
        .foregroundStyle(Color(hex: timerColorHex) ?? .white)
    }
    
    var timeControlButtons: some View {
        HStack {
            
            Button(action: {
                
                startTime = Date();
                timeRemaining = time * 60;
                timerIsRunning = true;
                
            }, label: {
                
                Text(timeRemaining > 0.0 ? "Restart" : "Start")
                
            })
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 5)
        }
    }
    
    var utilButtons: some View {
        HStack {
            
            preferencesButton
            
            Spacer()
            
            quitButton
            
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
        .padding(.top, -5)
    }
    
    var preferencesButton: some View {
        Button(action: {
            
            PreferencesController.shared.showWindow()
            
        }, label: {
            Text("Preferences")
        })
        .buttonStyle(.borderless)
    }
    
    var quitButton: some View {
        Button(action: {
            NSApplication.shared.terminate(nil)
        }, label: {
            Text("Quit")
        })
        .buttonStyle(.borderless)
    }
    
    func startTimer() {
        
        guard timeRemaining > 0.0 else { return }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            timeRemaining -= 1.0
            
            if timeRemaining <= 0.0 {
                
                timer.invalidate()
                
                audioManager.playSound()
                
                timerIsRunning = false;
                
            }
            
        }
        
    }
    
}
