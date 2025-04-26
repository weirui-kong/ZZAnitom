//
//  NSObject+ZZAHaptics.swift
//  ZZAnitom
//
//  Created by 孔维锐 on 4/26/25.
//

import UIKit
import ObjectiveC

private var kZZAHapticsEnabledKey: UInt8 = 0

extension NSObject {
    
    public var zzaHapticsEnabled: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &kZZAHapticsEnabledKey) as? Bool {
                return value
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &kZZAHapticsEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
