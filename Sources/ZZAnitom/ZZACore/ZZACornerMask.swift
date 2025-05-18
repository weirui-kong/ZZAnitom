//
//  ZZACornerMask.swift
//  ZZAnitom
//
//  Created by 孔维锐 on 5/18/25.
//

import Foundation
import QuartzCore

/// Option set to customize which corners of the modal should be rounded.
public struct ZZACornerMask: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let topLeft     = ZZACornerMask(rawValue: 1 << 0)
    public static let topRight    = ZZACornerMask(rawValue: 1 << 1)
    public static let bottomLeft  = ZZACornerMask(rawValue: 1 << 2)
    public static let bottomRight = ZZACornerMask(rawValue: 1 << 3)
    
    public static let allCorners: ZZACornerMask = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    
    /// Converts option set into CACornerMask used for layer masking.
    public var cornerMask: CACornerMask {
        var mask: CACornerMask = []
        if contains(.topLeft) { mask.insert(.layerMinXMinYCorner) }
        if contains(.topRight) { mask.insert(.layerMaxXMinYCorner) }
        if contains(.bottomLeft) { mask.insert(.layerMinXMaxYCorner) }
        if contains(.bottomRight) { mask.insert(.layerMaxXMaxYCorner) }
        return mask
    }
}
