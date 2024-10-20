//
//  AudioManager.swift
//  AtomVision
//
//  Created by Anvar Madvaliev on 03/07/24.
//

import AVFoundation
import Foundation

var player: AVAudioPlayer?

class AudioManager {
    func playSound() {
        let soundUrl = Bundle.main.path(forResource: "email_alert", ofType: "mp3")
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundUrl!))
            player?.prepareToPlay()
            player?.play()
        } catch {
            print(error)
        }
    }

    func stopSound() {
        player?.setVolume(0.0, fadeDuration: 0.25)
    }

}
