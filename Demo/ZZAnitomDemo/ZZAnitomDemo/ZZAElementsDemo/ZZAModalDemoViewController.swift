//
//  ZZAModalDemoViewController.swift
//  ZZAnitomDemo
//
//  Created by 孔维锐 on 5/18/25.
//

import Foundation
import UIKit
import SnapKit
import ZZAnitom
import UIKit
import SnapKit

class ZZAModalExampleContentView: UIView {
    
    var onClose: (() -> Void)?
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let closeButton = UIButton(type: .system)
    private let maxWidth: CGFloat = 450
    
    override var intrinsicContentSize: CGSize {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return CGSize(width: 300, height: 400)
        }
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let width = min(maxWidth, safeFrame.width - 20)
        
        let targetSize = CGSize(width: width - 40, height: UIView.layoutFittingCompressedSize.height)
        let contentHeight = contentStack.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        
        let buttonHeight: CGFloat = 44
        let verticalPadding: CGFloat = 24
        
        let height = contentHeight + buttonHeight + verticalPadding * 3
        
        let maxHeight = safeFrame.height - 50
        
        return CGSize(width: width, height: min(height, maxHeight))
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackground()
        setupScrollViewAndStack()
        setupCloseButton()
        setupContent()
    }

    private func setupBackground() {
        backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.systemIndigo : UIColor.systemBlue
        }
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.2, green: 0.4, blue: 0.85, alpha: 1).cgColor,
            UIColor(red: 0.15, green: 0.3, blue: 0.7, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 16
        gradientLayer.masksToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
        
        self.layoutSubviewsCallback = {
            gradientLayer.frame = self.bounds
        }
    }
    
    private func setupScrollViewAndStack() {
        addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }

        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.alignment = .fill
        contentStack.distribution = .fill
        scrollView.addSubview(contentStack)

        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20))
            make.width.equalTo(scrollView.snp.width).offset(-40)
        }
    }
    
    private func setupCloseButton() {
        addSubview(closeButton)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.backgroundColor = .white
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        closeButton.layer.cornerRadius = 22
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOpacity = 0.15
        closeButton.layer.shadowRadius = 6
        closeButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(140)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }

    private func setupContent() {
        let titleLabel = UILabel()
        titleLabel.text = "ZZAnitom"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        titleLabel.textAlignment = .center
        contentStack.addArrangedSubview(titleLabel)

        let divider = UIView()
        divider.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        contentStack.addArrangedSubview(divider)

        let descriptionLabel = UILabel()
        descriptionLabel.text = """
A lightweight, pure-Swift animation framework that delivers stunning animations even on lower-end devices.

一个轻量级、纯 Swift 编写的动画框架，能够在低端设备上也呈现出惊艳的动画效果。

ZZAnitom is a complete rewrite of my previous animation framework, Anitom, which was based on SwiftUI and may not be suitable for applications targeting lower iOS versions.
By migrating to UIKit, ZZAnitom offers greater compatibility and easier integration across multiple platforms.
The migration is expected to be completed by June 2025.

Note: Some use cases may require SnapKit for layout support.
"""
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        contentStack.addArrangedSubview(descriptionLabel)
    }

    @objc private func closeTapped() {
        onClose?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var layoutSubviewsCallback: (() -> Void)?
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSubviewsCallback?()
    }
}

class ZZAModalDemoViewController: UIViewController {

    private let cornerSwitches: [UISwitch] = [.init(), .init(), .init(), .init()]
    private let dismissSwitch = UISwitch()
    private let blurSegment = UISegmentedControl(items: ["Dim", "BlurLight", "BlurDark"])
    private let placementSegment = UISegmentedControl(items: ["Center", "Bottom"])
    private let animationSegment = UISegmentedControl(items: ["Fade", "Push"])
    private let showButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        let labelTitles = ["Top Left", "Top Right", "Bottom Left", "Bottom Right"]
        for (i, title) in labelTitles.enumerated() {
            cornerSwitches[i].isOn = true
            let label = UILabel()
            label.text = title
            
            let stack = UIStackView(arrangedSubviews: [label, cornerSwitches[i]])
            stack.axis = .horizontal
            stack.spacing = 8
            
            view.addSubview(stack)
            stack.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(100 + i * 40)
                make.leading.equalToSuperview().offset(20)
            }
        }

        let dismissLabel = UILabel()
        dismissLabel.text = "Dismiss on Background Tap"
        
        dismissSwitch.isOn = true
        let dismissStack = UIStackView(arrangedSubviews: [dismissLabel, dismissSwitch])
        dismissStack.axis = .horizontal
        dismissStack.spacing = 8
        
        view.addSubview(dismissStack)
        dismissStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(270)
            make.leading.equalToSuperview().offset(20)
        }

        blurSegment.selectedSegmentIndex = 1
        view.addSubview(blurSegment)
        blurSegment.snp.makeConstraints { make in
            make.top.equalTo(dismissStack.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(250)
        }

        placementSegment.selectedSegmentIndex = 0
        view.addSubview(placementSegment)
        placementSegment.snp.makeConstraints { make in
            make.top.equalTo(blurSegment.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(250)
        }

        animationSegment.selectedSegmentIndex = 1
        view.addSubview(animationSegment)
        animationSegment.snp.makeConstraints { make in
            make.top.equalTo(placementSegment.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(250)
        }

        showButton.setTitle("Show Modal", for: .normal)
        showButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        showButton.addTarget(self, action: #selector(showModal), for: .touchUpInside)
        
        view.addSubview(showButton)
        showButton.snp.makeConstraints { make in
            make.top.equalTo(animationSegment.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
    }

    @objc private func showModal() {
        var mask: ZZACornerMask = []
        if cornerSwitches[0].isOn { mask.insert(.topLeft) }
        if cornerSwitches[1].isOn { mask.insert(.topRight) }
        if cornerSwitches[2].isOn { mask.insert(.bottomLeft) }
        if cornerSwitches[3].isOn { mask.insert(.bottomRight) }

        let bgStyle: ZZAModalBackgroundStyle
        switch blurSegment.selectedSegmentIndex {
        case 0: bgStyle = .dimmedBlack
        case 1: bgStyle = .blur(style: .light)
        case 2: bgStyle = .blur(style: .dark)
        default: bgStyle = .dimmedBlack
        }

        let placement: ZZAModalPlacement = (placementSegment.selectedSegmentIndex == 0) ? .center : .bottom

        let animationStyle: ZZAModalAnimationStyle = (animationSegment.selectedSegmentIndex == 0) ? .fade : .push

        let contentView = ZZAModalExampleContentView()
        let modalVC = ZZAModalViewController(
            contentView: contentView,
            cornerMask: mask,
            dismissOnBackgroundTap: dismissSwitch.isOn,
            backgroundStyle: bgStyle,
            placement: placement,
            animationStyle: animationStyle
        )
        
        contentView.onClose = { [weak modalVC] in
            modalVC?.dismissModal()
        }
        
        present(modalVC, animated: false)
    }
}
