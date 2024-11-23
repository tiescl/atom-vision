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
    @AppStorage("timerColor") private var timerColorHex: String = "FFFFFF"
    
    var appState: AppDelegate
    var zenState: ZenState {
        return appState.zenState
    }

    @State private var startTime: Date = Date()
    @State private var timeRemaining: Double = 0.0
    @State private var timerController: Timer?

    private let MIN_IN_SEC = 60.0

    var breakTime: Double = 5.0
    var lazyTime: Double = 0.0
    var focusTime: Double {
        return Double(timerDurationText) ?? 30
    }
    
    let audioManager = AudioManager()

    var body: some View {
        VStack {
            zenStateReflector
            timer
            timeControlButtons
            Divider()
            utilButtons
        }
        .onChange(of: focusTime) {
            prepareTimer(for: .Focus)
        }
    }

    var timer: some View {
        Group {
            if timeRemaining <= 0.0 {
                Text("\(Int(focusTime)):00")
            } else {
                let interval = TimeInterval(
                    (zenState == .Focus ? focusTime : breakTime) * MIN_IN_SEC
                )
                Text(
                    startTime.addingTimeInterval(interval),
                    style: .timer
                )
            }
        }
        .font(.system(size: 70))
        .foregroundStyle(Color(hex: timerColorHex) ?? .white)
        .padding(.vertical, -10)
    }

    var timeControlButtons: some View {
        VStack {
            HStack {
                Button(
                    action: {
                        prepareTimer(for: .Break)
                    },
                    label: {
                        Text("Start \(Int(breakTime))")
                    }
                )
                Spacer()
                Button(
                    action: {
                        prepareTimer(for: .Focus)
                    },
                    label: {
                        Text("Start \(Int(focusTime))")
                    }
                )
            }
            .padding(.horizontal, 55)

            Button(
                action: {
                    prepareTimer(for: .Lazy)
                },
                label: {
                    Text("Reset")
                }
            )
            .padding(.top, 7)
        }
        .buttonStyle(.borderedProminent)
        .padding(.bottom, 5)
        .padding(.top, 10)
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
        Button(
            action: {
                PreferencesController.shared.showWindow()
            },
            label: {
                Text("Preferences")
            }
        )
        .buttonStyle(.borderless)
    }

    var quitButton: some View {
        Button(
            action: {
                NSApplication.shared.terminate(nil)
            },
            label: {
                Text("Quit")
            }
        )
        .buttonStyle(.borderless)
    }
    
    var zenStateReflector: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 1.0)
            Text("\(zenState)").font(.title3)
        }
        .foregroundStyle(Color(hex: timerColorHex) ?? .orange)
        .frame(width: 55.0, height: 25.0)
        .padding(.top, 10)
    }
    
    func prepareTimer(for futureZenState: ZenState) {
        timerController?.invalidate()
        
        appState.zenState = futureZenState
        var duration: Double
        switch futureZenState {
            case .Break:
                duration = breakTime
            case .Focus:
                duration = focusTime
            default:
                duration = lazyTime
        }
        timeRemaining = duration * MIN_IN_SEC
        startTime = Date()
        
        if duration > 0.0 {
            startTimer()
        }
    }
    
    func startTimer() {
        guard timeRemaining > 0.0 else {
            timerController?.invalidate()
            return
        }

        timerController = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            timeRemaining -= 1.0

            if timeRemaining == 0.0 {
                audioManager.playSound()
                timer.invalidate()
            }
        }
    }
}


