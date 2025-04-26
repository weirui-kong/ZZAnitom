//
//  ZZAImageStackViewDemoViewController.swift
//  ZZAnitomDemo
//
//  Created by 孔维锐 on 4/26/25.
//

import Foundation
import UIKit
import ZZAnitom
import SnapKit

class ZZAImageStackViewDemoViewController: UIViewController, ZZAImageStackViewDelegate {
    
    let stackView = ZZAImageStackView()
    let selectedImageView = UIImageView()
    let selectedIndexLabel = UILabel()
    let switchPlacementButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Setup stack view
        stackView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        stackView.center = view.center
        stackView.imageSize = CGSize(width: 200, height: 300)
        stackView.delegate = self
        stackView.images = [
            UIImage(named: "zzais_1")!,
            UIImage(named: "zzais_2")!,
            UIImage(named: "zzais_3")!,
            UIImage(named: "zzais_4")!
        ]
        view.addSubview(stackView)
        
        // Setup selected image view to show the selected image as a small thumbnail
        selectedImageView.contentMode = .scaleAspectFill
        selectedImageView.layer.cornerRadius = 8
        selectedImageView.layer.masksToBounds = true
        view.addSubview(selectedImageView)
        
        // Setup selected index label
        selectedIndexLabel.text = "Selected Index: None"
        selectedIndexLabel.textColor = .black
        selectedIndexLabel.textAlignment = .center
        view.addSubview(selectedIndexLabel)
        
        // Setup switch placement button
        switchPlacementButton.setTitle("Switch Placement", for: .normal)
        switchPlacementButton.backgroundColor = .systemBlue
        switchPlacementButton.layer.cornerRadius = 8
        switchPlacementButton.addTarget(self, action: #selector(switchPlacement), for: .touchUpInside)
        view.addSubview(switchPlacementButton)
        
        // Layout using SnapKit
        selectedImageView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)  // Small image thumbnail
        }
        
        selectedIndexLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        switchPlacementButton.snp.makeConstraints { make in
            make.top.equalTo(selectedIndexLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
    }
    
    // MARK: - ZZAImageStackViewDelegate
    
    func imageStackView(_ stackView: ZZAImageStackView, didTapImageAt index: Int) {
        selectedIndexLabel.text = "Selected Index: \(index)"
        if let tappedImage = stackView.images[safe: index] {
            selectedImageView.image = tappedImage  // Display tapped image in small image view
        }
    }
    
    func imageStackView(_ stackView: ZZAImageStackView, didTapImage image: UIImage?) {
        print("Image tapped as \(image?.accessibilityIdentifier ?? "Unknown")")
    }
    
    // MARK: - Button Action
    
    @objc private func switchPlacement() {
        stackView.placement = stackView.placement == .clockwise ? .counterClockwise : .clockwise
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
