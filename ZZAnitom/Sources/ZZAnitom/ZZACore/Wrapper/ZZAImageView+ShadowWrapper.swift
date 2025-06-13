//
//  ZZAImageView+ShadowWrapper.swift
//  ZZAnitom
//
//  Created by 孔维锐 on 4/26/25.
//

import Foundation
import UIKit

extension ZZAImageView {
    var zza_shadowColor: UIColor? {
        get { UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor) }
        set { layer.shadowColor = newValue?.cgColor }
    }

    var zza_shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    var zza_shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    var zza_shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
}
