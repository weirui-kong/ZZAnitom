//
//  ZZAHapticManager.swift
//  ZZAnitom
//
//  Created by 孔维锐 on 4/26/25.
//

import UIKit
import CoreHaptics

/// Haptic feedback types
@objc public enum ZZAHapticType: Int {
    case lightImpact               // Light impact
    case mediumImpact              // Medium impact
    case heavyImpact               // Heavy impact
    case success                   // Success notification
    case warning                   // Warning notification
    case error                     // Error notification
}

/// Advanced Haptic Manager (Singleton)
@objc public final class ZZAHapticManager: NSObject {
    
    @objc public static let shared = ZZAHapticManager()
    
    private var engine: CHHapticEngine?
    
    private override init() {
        super.init()
        prepareEngine()
    }
    
    /// Prepare haptic engine
    private func prepareEngine() {
        guard #available(iOS 13.0, *) else { return }
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("[ZZAHapticsManager] Device does not support Haptics.")
            return
        }
        
        do {
            engine = try CHHapticEngine()
            engine?.stoppedHandler = { reason in
                print("[ZZAHapticsManager] Engine stopped: \(reason.rawValue)")
            }
            engine?.resetHandler = { [weak self] in
                print("[ZZAHapticsManager] Engine reset, trying to restart.")
                self?.prepareEngine()
            }
            try engine?.start()
        } catch {
            print("[ZZAHapticsManager] Failed to start haptic engine: \(error)")
        }
    }
    
    /// Restart engine if not available
    private func restartEngineIfNeeded() {
        guard #available(iOS 13.0, *) else { return }
        
        do {
            try engine?.start()
        } catch {
            print("[ZZAHapticsManager] Engine failed to start, re-preparing: \(error)")
            prepareEngine()
        }
    }
    
    // MARK: - Public API
    
    /// Play a haptic feedback
    @objc public func play(_ type: ZZAHapticType) {
        guard #available(iOS 13.0, *) else { return }
        
        switch type {
        case .lightImpact:
            simpleImpact(intensity: 0.3, sharpness: 0.7)
            
        case .mediumImpact:
            simpleImpact(intensity: 0.5, sharpness: 0.5)
            
        case .heavyImpact:
            simpleImpact(intensity: 1.0, sharpness: 0.7)
            
        case .success:
            notificationHaptic(type: .success)
            
        case .warning:
            notificationHaptic(type: .warning)
            
        case .error:
            notificationHaptic(type: .error)
        }
    }
    
    // MARK: - Public Functions for Continuous and Custom Haptics
    
    /// Play continuous vibration for a specified duration
    @objc public func playContinuousVibration(duration: TimeInterval, intensity: Float = 0.7) {
        guard #available(iOS 13.0, *) else { return }
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let continuousEvent = CHHapticEvent(
            eventType: .hapticContinuous,  // Continuous event type
            parameters: [
                .init(parameterID: .hapticIntensity, value: intensity),
                .init(parameterID: .hapticSharpness, value: 0.5)
            ],
            relativeTime: 0,
            duration: duration  // Set duration for continuous vibration
        )
        
        play(events: [continuousEvent])
    }
    
    /// Play custom haptic feedback
    @objc public func playCustomHaptic(intensity: Float, sharpness: Float, duration: TimeInterval) {
        guard #available(iOS 13.0, *) else { return }
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: intensity),
                .init(parameterID: .hapticSharpness, value: sharpness)
            ],
            relativeTime: 0
        )
        
        play(events: [event])
    }
    
    // MARK: - Private
    
    /// Play a simple impact feedback
    private func simpleImpact(intensity: Float, sharpness: Float) {
        guard #available(iOS 13.0, *) else { return }
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: intensity),
                .init(parameterID: .hapticSharpness, value: sharpness)
            ],
            relativeTime: 0
        )
        
        play(events: [event])
    }
    
    /// Play a notification feedback (success, warning, error)
    private func notificationHaptic(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    /// Internal play function
    private func play(events: [CHHapticEvent]) {
        guard #available(iOS 13.0, *) else { return }
        
        do {
            restartEngineIfNeeded()
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("[ZZAHapticsManager] Failed to play haptic pattern: \(error)")
        }
    }
    
}
