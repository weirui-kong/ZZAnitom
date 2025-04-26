//
//  ZZAHapticsManagerDemoViewController.swift
//  ZZAnitom
//
//  Created by 孔维锐 on 4/26/25.
//

import UIKit
import ZZAnitom

class ZZAHapticsManagerDemoViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let lightImpactButton = UIButton()
    private let mediumImpactButton = UIButton()
    private let heavyImpactButton = UIButton()
    private let successButton = UIButton()
    private let warningButton = UIButton()
    private let errorButton = UIButton()
    private let continuousVibrationButton = UIButton()
    private let customHapticButton = UIButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view controller
        view.backgroundColor = .white
        setupButtons()
    }
    
    // MARK: - Setup UI
    
    private func setupButtons() {
        // Light Impact Button
        lightImpactButton.setTitle("Light Impact", for: .normal)
        lightImpactButton.backgroundColor = .systemBlue
        lightImpactButton.addTarget(self, action: #selector(lightImpactTapped), for: .touchUpInside)
        lightImpactButton.frame = CGRect(x: 50, y: 100, width: 200, height: 50)
        view.addSubview(lightImpactButton)
        
        // Medium Impact Button
        mediumImpactButton.setTitle("Medium Impact", for: .normal)
        mediumImpactButton.backgroundColor = .systemBlue
        mediumImpactButton.addTarget(self, action: #selector(mediumImpactTapped), for: .touchUpInside)
        mediumImpactButton.frame = CGRect(x: 50, y: 170, width: 200, height: 50)
        view.addSubview(mediumImpactButton)
        
        // Heavy Impact Button
        heavyImpactButton.setTitle("Heavy Impact", for: .normal)
        heavyImpactButton.backgroundColor = .systemBlue
        heavyImpactButton.addTarget(self, action: #selector(heavyImpactTapped), for: .touchUpInside)
        heavyImpactButton.frame = CGRect(x: 50, y: 240, width: 200, height: 50)
        view.addSubview(heavyImpactButton)
        
        // Success Button
        successButton.setTitle("Success", for: .normal)
        successButton.backgroundColor = .systemGreen
        successButton.addTarget(self, action: #selector(successTapped), for: .touchUpInside)
        successButton.frame = CGRect(x: 50, y: 310, width: 200, height: 50)
        view.addSubview(successButton)
        
        // Warning Button
        warningButton.setTitle("Warning", for: .normal)
        warningButton.backgroundColor = .systemOrange
        warningButton.addTarget(self, action: #selector(warningTapped), for: .touchUpInside)
        warningButton.frame = CGRect(x: 50, y: 380, width: 200, height: 50)
        view.addSubview(warningButton)
        
        // Error Button
        errorButton.setTitle("Error", for: .normal)
        errorButton.backgroundColor = .systemRed
        errorButton.addTarget(self, action: #selector(errorTapped), for: .touchUpInside)
        errorButton.frame = CGRect(x: 50, y: 450, width: 200, height: 50)
        view.addSubview(errorButton)
        
        // Continuous Vibration Button
        continuousVibrationButton.setTitle("Continuous Vibration", for: .normal)
        continuousVibrationButton.backgroundColor = .systemPurple
        continuousVibrationButton.addTarget(self, action: #selector(continuousVibrationTapped), for: .touchUpInside)
        continuousVibrationButton.frame = CGRect(x: 50, y: 520, width: 200, height: 50)
        view.addSubview(continuousVibrationButton)
        
        // Custom Haptic Button
        customHapticButton.setTitle("Custom Haptic", for: .normal)
        customHapticButton.backgroundColor = .systemTeal
        customHapticButton.addTarget(self, action: #selector(customHapticTapped), for: .touchUpInside)
        customHapticButton.frame = CGRect(x: 50, y: 590, width: 200, height: 50)
        view.addSubview(customHapticButton)
    }
    
    // MARK: - Button Actions
    
    @objc private func lightImpactTapped() {
        ZZAHapticManager.shared.play(.lightImpact)
    }
    
    @objc private func mediumImpactTapped() {
        ZZAHapticManager.shared.play(.mediumImpact)
    }
    
    @objc private func heavyImpactTapped() {
        ZZAHapticManager.shared.play(.heavyImpact)
    }
    
    @objc private func successTapped() {
        ZZAHapticManager.shared.play(.success)
    }
    
    @objc private func warningTapped() {
        ZZAHapticManager.shared.play(.warning)
    }
    
    @objc private func errorTapped() {
        ZZAHapticManager.shared.play(.error)
    }
    
    @objc private func continuousVibrationTapped() {
        ZZAHapticManager.shared.playContinuousVibration(duration: 2.0)
    }
    
    @objc private func customHapticTapped() {
        ZZAHapticManager.shared.playCustomHaptic(intensity: 0.8, sharpness: 0.5, duration: 0.5)
    }
}
