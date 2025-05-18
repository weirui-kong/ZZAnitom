//
//  ZZAModalViewController.swift
//  ZZAnitom
//
//  Created by 孔维锐 on 5/18/25.
//

import UIKit
import SnapKit

// MARK: Enum and OptionSet

public enum ZZAModalBackgroundStyle {
    case dimmedBlack
    case blur(style: UIBlurEffect.Style)
}

public enum ZZAModalPlacement {
    case center
    case bottom
}

public enum ZZAModalAnimationStyle {
    case push
    case fade
}

// MARK: - ZZAModalViewController

/// A customizable modal view controller which supports different background styles, corner masks, placements and animations.
public class ZZAModalViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let contentView: UIView
    private let cornerMask: ZZACornerMask
    private let dismissOnBackgroundTap: Bool
    private let backgroundStyle: ZZAModalBackgroundStyle
    private let placement: ZZAModalPlacement
    private let animationStyle: ZZAModalAnimationStyle
    private let bottomPadding: CGFloat?
    
    /// Callback that is triggered upon modal dismissal.
    public var onDismiss: (() -> Void)?
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private var containerBottomConstraint: Constraint?
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `ZZAModalViewController`.
    ///
    /// - Parameters:
    ///   - contentView: The content view to be displayed inside the modal.
    ///   - cornerMask: The corner mask for rounding specific corners. Defaults to all corners.
    ///   - dismissOnBackgroundTap: Determines whether tapping on the background dismisses the modal.
    ///   - backgroundStyle: The style of the background.
    ///   - placement: The placement of the modal (center or bottom).
    ///   - animationStyle: The animation style used for presenting/dismissing the modal.
    ///   - bottomPadding: The custom bottom padding when the modal is placed at bottom. If nil, uses the device's safe area inset.
    public init(contentView: UIView,
                cornerMask: ZZACornerMask = .allCorners,
                dismissOnBackgroundTap: Bool = true,
                backgroundStyle: ZZAModalBackgroundStyle = .dimmedBlack,
                placement: ZZAModalPlacement = .center,
                animationStyle: ZZAModalAnimationStyle = .push,
                bottomPadding: CGFloat? = nil) {
        self.contentView = contentView
        self.cornerMask = cornerMask
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        self.backgroundStyle = backgroundStyle
        self.placement = placement
        self.animationStyle = animationStyle
        self.bottomPadding = bottomPadding
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupContent()
        setupGesture()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateIn()
    }
    
    // MARK: - Setup Methods
    
    /// Configures the background view based on the background style.
    private func setupBackground() {
        switch backgroundStyle {
        case .dimmedBlack:
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        case .blur(let style):
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
            blurView.frame = view.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundView.addSubview(blurView)
        }
        
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundView)
    }
    
    /// Configures the container view that holds the content view.
    private func setupContent() {
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = cornerMask.cornerMask
        containerView.layer.masksToBounds = true
        
        containerView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.width.equalTo(contentView.intrinsicContentSize.width)
            make.height.equalTo(contentView.intrinsicContentSize.height)
            make.centerX.equalToSuperview()
            
            switch placement {
            case .center:
                make.centerY.equalToSuperview()
            case .bottom:
                switch animationStyle {
                case .fade:
                    let padding = bottomPadding ?? view.safeAreaInsets.bottom
                    containerBottomConstraint = make.bottom.equalTo(bottomPadding == nil ? view.safeAreaLayoutGuide.snp.bottom : view.snp.bottom).offset(-padding).constraint

                case .push:
                    let padding = bottomPadding ?? view.safeAreaInsets.bottom
                    containerBottomConstraint = make.bottom.equalTo(bottomPadding == nil ? view.safeAreaLayoutGuide.snp.bottom : view.snp.bottom).offset(contentView.intrinsicContentSize.height - padding).constraint

                }
            }
        }
    }
    
    /// Sets up the background tap gesture recognizer for dismissing the modal.
    private func setupGesture() {
        if dismissOnBackgroundTap {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
            tapGesture.cancelsTouchesInView = false
            backgroundView.addGestureRecognizer(tapGesture)
        }
    }
    
    // MARK: - Animation Methods
    
    /// Performs the animation for presenting the modal.
    private func animateIn() {
        // Fade in the background view
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
        }
        
        switch animationStyle {
        case .push:
            switch placement {
            case .center:
                containerView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.8,
                               options: [.curveEaseInOut]) {
                    self.containerView.transform = .identity
                }
            case .bottom:
                self.view.layoutIfNeeded()
                
                let padding = bottomPadding ?? view.safeAreaInsets.bottom
                containerBottomConstraint?.update(offset: -padding)

                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.8,
                               options: [.curveEaseInOut]) {
                    self.view.layoutIfNeeded()
                }
            }
        case .fade:
            containerView.alpha = 0
            containerView.transform = .identity
            UIView.animate(withDuration: 0.3) {
                self.containerView.alpha = 1
            }
        }
    }
    
    /// Performs the animation for dismissing the modal.
    ///
    /// - Parameter completion: A closure that gets called after the animation completes.
    private func animateOut(completion: @escaping () -> Void) {
        // Fade out the background view
        UIView.animate(withDuration: 0.5) {
            self.backgroundView.alpha = 0
        }
        
        switch animationStyle {
        case .push:
            switch placement {
            case .center:
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.8,
                               options: [.curveEaseIn]) {
                    self.containerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                } completion: { _ in
                    completion()
                }
            case .bottom:
                let screenHeight = self.view.window?.bounds.height ?? self.view.bounds.height
                let containerOriginY = self.containerView.frame.origin.y
                let containerHeight = self.containerView.frame.height
                let padding = bottomPadding ?? view.safeAreaInsets.bottom
                let slideOutOffset = screenHeight - containerOriginY + containerHeight + padding

                containerBottomConstraint?.update(offset: slideOutOffset)

                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.8,
                               options: [.curveEaseIn]) {
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    completion()
                }
            }
        case .fade:
            UIView.animate(withDuration: 0.5, animations: {
                self.containerView.alpha = 0
            }, completion: { _ in completion() })
        }
    }
    
    // MARK: - Action Methods
    
    /// Handler for background tap gesture to dismiss the modal.
    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        dismissModal()
    }
    
    // MARK: - Public Methods
    
    /// Dismisses the modal with an animation.
    ///
    /// - Parameter completion: An optional completion closure that will be called after dismissal.
    public func dismissModal(completion: (() -> Void)? = nil) {
        animateOut { [weak self] in
            self?.dismiss(animated: false, completion: {
                self?.onDismiss?()
                completion?()
            })
        }
    }
}
