//
//  ZZAImageView+BlurWrapper.swift
//  ZZAnitom
//
//  Created by 孔维锐 on 4/26/25.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import ObjectiveC

internal var zza_ImageViewBlurLayerKey: UInt8 = 0
private var ciContext = CIContext()

extension ZZAImageView {
    var zza_blurRadius: CGFloat {
        get {
            if let blurLayer = objc_getAssociatedObject(self, &zza_ImageViewBlurLayerKey) as? CALayer,
               let radius = blurLayer.value(forKey: "zza_blurRadius") as? CGFloat {
                return radius
            }
            return 0
        }
        set {
            if newValue <= 0 {
                removeBlur()
            } else {
                applyBlur(radius: newValue)
            }
        }
    }
    
    private func applyBlur(radius: CGFloat) {
        guard let sourceImage = image else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let ciImage = CIImage(image: sourceImage)
            let filter = CIFilter.gaussianBlur()
            filter.inputImage = ciImage
            filter.radius = Float(radius)
            
            guard let outputImage = filter.outputImage else { return }
            guard let cgImage = ciContext.createCGImage(outputImage, from: ciImage!.extent) else { return }
            let blurredImage = UIImage(cgImage: cgImage)
            
            DispatchQueue.main.async {
                self.setBlurredImage(blurredImage, radius: radius)
            }
        }
    }
    
    private func setBlurredImage(_ blurredImage: UIImage, radius: CGFloat) {
        var blurLayer = objc_getAssociatedObject(self, &zza_ImageViewBlurLayerKey) as? CALayer
        
        if blurLayer == nil {
            blurLayer = CALayer()
            blurLayer?.frame = bounds
            blurLayer?.contentsGravity = .resizeAspectFill
            blurLayer?.masksToBounds = false
            blurLayer?.zPosition = 1
            self.imageView.layer.addSublayer(blurLayer!)  // Apply blur to the imageView's layer
            objc_setAssociatedObject(self, &zza_ImageViewBlurLayerKey, blurLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        blurLayer?.contents = blurredImage.cgImage
        blurLayer?.frame = bounds
        blurLayer?.setValue(radius, forKey: "zza_blurRadius")
    }
    
    private func removeBlur() {
        if let blurLayer = objc_getAssociatedObject(self, &zza_ImageViewBlurLayerKey) as? CALayer {
            blurLayer.removeFromSuperlayer()
            objc_setAssociatedObject(self, &zza_ImageViewBlurLayerKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
