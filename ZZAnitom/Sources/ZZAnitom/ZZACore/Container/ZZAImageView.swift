//
//  ZZAImageView.swift
//  ZZAnitom
//
//  Created by 孔维锐 on 4/26/25.
//

import UIKit

class ZZAImageView: UIView {
    internal var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var zza_contentMode: UIView.ContentMode {
        get {
            return imageView.contentMode
        }
        set {
            imageView.contentMode = newValue
        }
    }
    
    var zza_cornerRadius: CGFloat {
        get {
            return imageView.layer.cornerRadius
        }
        set {
            imageView.layer.cornerRadius = newValue
        }
    }
    
    var zza_masksToBounds: Bool {
        get {
            return imageView.layer.masksToBounds
        }
        set {
            imageView.layer.masksToBounds = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        
        if let blurLayer = objc_getAssociatedObject(self, &zza_ImageViewBlurLayerKey) as? CALayer {
            blurLayer.frame = bounds
        }
    }

}
