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
    let increaseSizeButton = UIButton()
    let decreaseSizeButton = UIButton()
    let forwardScrollButton = UIButton()
    let backwardScrollButton = UIButton()

    // 原始比例
    private let aspectRatio: CGFloat = 3.0 / 2.0  // 高宽比（300/200）

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Setup stack view
        stackView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
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
        
        // Setup increase size button
        increaseSizeButton.setTitle("Increase Size", for: .normal)
        increaseSizeButton.backgroundColor = .systemGreen
        increaseSizeButton.layer.cornerRadius = 8
        increaseSizeButton.addTarget(self, action: #selector(increaseImageSize), for: .touchUpInside)
        view.addSubview(increaseSizeButton)
        
        // Setup decrease size button
        decreaseSizeButton.setTitle("Decrease Size", for: .normal)
        decreaseSizeButton.backgroundColor = .systemRed
        decreaseSizeButton.layer.cornerRadius = 8
        decreaseSizeButton.addTarget(self, action: #selector(decreaseImageSize), for: .touchUpInside)
        view.addSubview(decreaseSizeButton)
        
        // Setup forward scroll button
        forwardScrollButton.setTitle("Forward →", for: .normal)
        forwardScrollButton.backgroundColor = .systemOrange
        forwardScrollButton.layer.cornerRadius = 8
        forwardScrollButton.addTarget(self, action: #selector(scrollForward), for: .touchUpInside)
        view.addSubview(forwardScrollButton)

        // Setup backward scroll button
        backwardScrollButton.setTitle("← Backward", for: .normal)
        backwardScrollButton.backgroundColor = .systemPurple
        backwardScrollButton.layer.cornerRadius = 8
        backwardScrollButton.addTarget(self, action: #selector(scrollBackward), for: .touchUpInside)
        view.addSubview(backwardScrollButton)

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
        
        increaseSizeButton.snp.makeConstraints { make in
            make.top.equalTo(switchPlacementButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.height.equalTo(44)
            make.width.equalTo(140)
        }
        
        decreaseSizeButton.snp.makeConstraints { make in
            make.top.equalTo(switchPlacementButton.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(44)
            make.width.equalTo(140)
        }
        
        backwardScrollButton.snp.makeConstraints { make in
            make.top.equalTo(increaseSizeButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.height.equalTo(44)
            make.width.equalTo(140)
        }
        forwardScrollButton.snp.makeConstraints { make in
            make.top.equalTo(decreaseSizeButton.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(44)
            make.width.equalTo(140)
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
    
    // MARK: - Button Actions
    
    @objc private func switchPlacement() {
        stackView.placement = stackView.placement == .clockwise ? .counterClockwise : .clockwise
    }
    
    @objc private func increaseImageSize() {
        let newWidth = stackView.imageSize.width + 20
        let newHeight = newWidth * aspectRatio
        stackView.imageSize = CGSize(width: newWidth, height: newHeight)
    }
    
    @objc private func decreaseImageSize() {
        let newWidth = max(40, stackView.imageSize.width - 20)  // 最小宽度限制40
        let newHeight = newWidth * aspectRatio
        stackView.imageSize = CGSize(width: newWidth, height: newHeight)
    }
    
    @objc private func scrollForward() {
        stackView.scroll(by: 1)
    }

    @objc private func scrollBackward() {
        stackView.scroll(by: -1)
    }

}

// MARK: - Safe Array Access
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
