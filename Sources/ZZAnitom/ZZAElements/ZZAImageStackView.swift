//
//  ZZAImageStackView.swift
//  ZZAnitom
//
//  Created by 孔维锐 on 4/26/25.
//

import UIKit
import CoreImage

@objc public protocol ZZAImageStackViewDelegate: AnyObject {
    @objc optional func imageStackView(_ stackView: ZZAImageStackView, didTapImageAt index: Int)
    @objc optional func imageStackView(_ stackView: ZZAImageStackView, didTapImage image: UIImage?)
}

@objc public class ZZAImageStackView: UIView {

    // MARK: - Public Properties

    /// Images to be displayed in the stack
    public var images: [UIImage] = [] {
        didSet {
            setupImageViews()
        }
    }

    /// Size of each image
    public var imageSize: CGSize = CGSize(width: 200, height: 300) {
        didSet {
            updateImageLayouts()
        }
    }
    

    /// Spacing between images (not directly used yet, reserved for future)
    public var imageSpacing: CGFloat = 10

    /// Corner radius ratio based on the smallest side
    public var cornerRadiusRatio: CGFloat = 0.1

    /// Rotation angle for each stacked image
    public var rotationAngleUnit: CGFloat = 10.0

    /// Drag threshold before triggering a card move
    public var dragThreshold: CGFloat = 50

    /// Rotation direction of the stack
    public var placement: ZZARotationDirection = .clockwise {
        didSet {
            self.updateImageLayouts()
        }
    }

    /// Whether to enable advanced 3D drag effect
    @available(*, deprecated, message: "This feature is not implemented yet.")
    public var advanced3DEffectEnabled: Bool = false
    /// Whether to enable pinch scale effect
    @available(*, deprecated, message: "This feature is not sufficiently implemented yet.")
    public var pinchEnabled: Bool = false

    /// Delegate for tap callbacks
    public weak var delegate: ZZAImageStackViewDelegate?

    // MARK: - Private Properties

    private var imageViews: [ZZAImageView] = []
    private var panGesture: UIPanGestureRecognizer!
    private var pinchGesture: UIPinchGestureRecognizer!
    private var dragOffset: CGPoint = .zero
    private var dragRotation: CGFloat = 0

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        clipsToBounds = false
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
        if (pinchEnabled) {
            pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
            addGestureRecognizer(pinchGesture)
        }
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    /// Initialize and setup image views when images are set
    private func setupImageViews() {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = []

        for (index, image) in images.enumerated() {
            let imageView = ZZAImageView()
            imageView.image = image
            imageView.frame.size = imageSize
            imageView.isUserInteractionEnabled = true
            imageView.zza_contentMode = .scaleAspectFill
            imageView.zza_cornerRadius = cornerRadiusRatio * min(imageSize.width, imageSize.height)
            imageView.zza_masksToBounds = true
            imageView.tag = index

            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            imageView.addGestureRecognizer(tap)

            addSubview(imageView)
            imageViews.append(imageView)
        }
        updateImageEffects()
        updateImageLayouts()
    }

    /// Update image layouts (position, rotation, zIndex)
    private func updateImageLayouts(cutOffAt: Int = Int(INT_MAX), animated: Bool = true) {
        guard !images.isEmpty else { return }
        let count = min(images.count, cutOffAt)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            
            for i in 0..<count {
                let imageView = self.imageViews[i]
                imageView.bounds.size = self.imageSize
                
                // Calculate rotation angle
                let angle = CGFloat(i) * (self.placement.sign() * self.rotationAngleUnit) + self.dragRotation
                let radians = angle * .pi / 180
                
                // Calculate pivot compensation
                let pivotX: CGFloat = (self.placement == .clockwise) ? self.imageSize.width : 0
                let pivotY: CGFloat = self.imageSize.height
                let dx = pivotX - (self.imageSize.width / 2)
                let dy = pivotY - (self.imageSize.height / 2)
                
                var transform = CGAffineTransform.identity
                transform = transform.translatedBy(x: dx, y: dy)
                transform = transform.rotated(by: radians)
                transform = transform.translatedBy(x: -dx, y: -dy)
                
                transform = transform.translatedBy(x: self.dragOffset.x, y: self.dragOffset.y)

                
                var layerTransform = CATransform3DMakeAffineTransform(transform)
                
                // Add advanced 3D rotation effect to top image
                if self.advanced3DEffectEnabled  {
                    // TODO: Implement 3d effects.
                }
                
                // Center image view inside self
                imageView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
                imageView.layer.transform = layerTransform
                imageView.layer.zPosition = -CGFloat(i)
            }
        }
    }

    /// Update visual effects like blur, shadows and alpha
    private func updateImageEffects(animated: Bool = true) {
        guard !images.isEmpty else { return }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            for (i, imageView) in self.imageViews.enumerated() {
                imageView.zza_blurRadius = 3 * CGFloat(i)
                imageView.zza_shadowColor = UIColor.black
                imageView.zza_shadowOpacity = 0.25
                imageView.zza_shadowOffset = CGSize(width: 0, height: 2)
                imageView.zza_shadowRadius = 5
                imageView.alpha = CGFloat(1.5 - Double(i) * 0.45)
            }
        }
    }

    // MARK: - Gesture Handlers

    /// Handle tap on images
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        delegate?.imageStackView?(self, didTapImage: imageViews.first(where: { $0.tag == tag })?.image)
        delegate?.imageStackView?(self, didTapImageAt: tag)
    }

    /// Handle dragging gesture to move top image
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        switch gesture.state {
        case .changed:
            dragOffset = applyDragOffsetThresholdMapping(to: translation)
            dragRotation = applyDragRotationThresholdMapping(to: translation)
            self.updateImageLayouts(cutOffAt: 1)

        case .ended:
            if abs(translation.x) > dragThreshold || abs(translation.y) > dragThreshold {
                let movedView = imageViews.removeFirst()
                imageViews.append(movedView)
            }
            dragOffset = .zero
            dragRotation = 0
            self.updateImageEffects()
            self.updateImageLayouts()
            if (self.zzaHapticsEnabled) {
                ZZAHapticManager.shared.play(.mediumImpact)
            }
        default:
            break
        }
    }

    /// Handle the pinch gesture
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        let scale = gesture.scale
        
        // Apply scaling to the image views during the pinch
        if gesture.state == .changed {
            for imageView in imageViews {
                imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            // Reset the scale back to 1.0 after pinch ends
            UIView.animate(withDuration: 0.3) {
                for imageView in self.imageViews {
                    imageView.transform = CGAffineTransform.identity
                }
            }
        }
    }
    // MARK: - Helpers

    /// Map translation to drag offset with threshold
    private func applyDragOffsetThresholdMapping(to translation: CGPoint) -> CGPoint {
        let maxTranslation = dragThreshold * 1.15
        let factor: CGFloat = 0.1
        let distance = hypot(translation.x, translation.y)

        if distance > maxTranslation {
            let scale = maxTranslation + (distance - maxTranslation) * factor
            let adjustedX = (translation.x / distance) * scale
            let adjustedY = (translation.y / distance) * scale
            return CGPoint(x: adjustedX, y: adjustedY)
        } else {
            return translation
        }
    }

    /// Map translation to drag rotation with threshold
    private func applyDragRotationThresholdMapping(to translation: CGPoint) -> CGFloat {
        let maxTranslation = dragThreshold * 1.1
        let factor: CGFloat = 0.1
        let maxRotation: CGFloat = 15.0
        let distance = hypot(translation.x, translation.y)

        if distance > maxTranslation {
            let scale = maxTranslation + (distance - maxTranslation) * factor
            let adjustedX = (translation.x / distance) * scale
            return (adjustedX * maxRotation) / maxTranslation
        } else {
            return (translation.x * maxRotation) / maxTranslation
        }
    }

    // MARK: - Hit Testing

    /// Allow gesture to penetrate to subviews
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for imageView in imageViews {
            let convertedPoint = imageView.convert(point, from: self)
            if let hitView = imageView.hitTest(convertedPoint, with: event) {
                return hitView
            }
        }
        return super.hitTest(point, with: event)
    }

}
