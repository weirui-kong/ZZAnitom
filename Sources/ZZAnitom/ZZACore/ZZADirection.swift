//
//  ZZADirection.swift
//  ZZAnitom
//
//  Created by 孔维锐 on 4/26/25.
//

import Foundation

public enum ZZARotationDirection: String, CaseIterable {
    case clockwise = "clockwise"
    case counterClockwise = "counterClockwise"
    
    func sign() -> CGFloat {
        return self == .clockwise ? 1 : -1
    }
}
