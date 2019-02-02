//
//  PinIndicator.swift
//  SimplePasscodeView
//
//  Copyright © 2018 Geeko Coco. All rights reserved.
//

import UIKit
class PinIndicator: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        rounded()
    }
}

extension PinIndicator: PinViewConfigurable {
    func rounded() {
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = pinborderWidth
        layer.borderColor = pinborderColor
    }
    
    func clearView() {
        backgroundColor = .clear
    }
    
    func fillView() {
        backgroundColor = pinfillColor
    }
}
