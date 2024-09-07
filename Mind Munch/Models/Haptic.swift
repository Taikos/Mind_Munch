//
//  Haptic.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import Foundation
import UIKit
import SwiftUI
import CoreHaptics

// MARK: - Haptic Manager
enum HapticFeedbackLevel {
    case light
    case medium
    case strong
}

class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    private var engine: CHHapticEngine?
    
    private init() {
        createEngine()
    }
    
    private func createEngine() {
        do {
            engine = try CHHapticEngine()
            engine?.stoppedHandler = { reason in
                print("Haptic engine stopped for reason: \(reason.rawValue)")
                switch reason {
                case .audioSessionInterrupt:
                    print("Audio session interrupted")
                case .applicationSuspended:
                    print("Application suspended")
                case .idleTimeout:
                    print("Engine idle timeout")
                case .systemError:
                    print("System error occurred")
                case .notifyWhenFinished:
                    print("Engine Finished")
                case .engineDestroyed:
                    print("Engine Destroyed")
                case .gameControllerDisconnect:
                    print("Engine Disconnected")
                @unknown default:
                    print("Unknown reason")
                }
                self.startEngine()
            }
            engine?.resetHandler = {
                print("Haptic engine reset")
                self.startEngine()
            }
            try engine?.start()
            print("Haptic engine successfully started")
        } catch {
            print("Haptic Engine Creation Error: \(error.localizedDescription)")
        }
    }
    
    private func startEngine() {
        do {
            try engine?.start()
            print("Haptic engine successfully restarted")
        } catch {
            print("Haptic Engine Start Error: \(error.localizedDescription)")
        }
    }
    
    func hapticFeedback(_ level: HapticFeedbackLevel) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Device does not support haptics")
            return
        }

        var events = [CHHapticEvent]()

        switch level {
        case .light:
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.9)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
            events.append(event)
        case .medium:
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
            events.append(event)
        case .strong:
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            for i in 0..<3 {
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: Double(i) * 0.1)
                events.append(event)
            }
        }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: CHHapticTimeImmediate)
            print("Haptic feedback triggered")
        } catch {
            print("Haptic Feedback Error: \(error.localizedDescription)")
        }
    }
}
