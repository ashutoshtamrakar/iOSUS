//
//  UITextFieldExtension.swift
//  TechnicalTest
//
//  Created by AT on 21/02/18.
//  Copyright © 2018 UbiqueSystems. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    struct Attributes {
        
        static let underlineColor = UIColor.white.cgColor
        static let lineWidth = CGFloat(1.0)
        static let rightViewDimension = CGFloat(20.0)
    }
    
    
    func rightViewFrame() -> CGRect {
        
        return CGRect(x: CGFloat(self.frame.size.width - Attributes.rightViewDimension),
                      y: Attributes.rightViewDimension, width: Attributes.rightViewDimension,
                      height: Attributes.rightViewDimension)
    }
    
    func drawUnderline(withColor color: CGColor, width: CGFloat) {
        
        let caLayer = CALayer()
        caLayer.borderColor = color
        caLayer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        caLayer.borderWidth = width
        
        self.layer.addSublayer(caLayer)
        self.layer.masksToBounds = true
    }
    
    func drawRightView(rectangle rect: CGRect, imageName: String, toggle: (target: Any, action: Selector)? = nil) {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        button.frame = rect
        button.addTarget(toggle?.target, action: (toggle?.action)!, for: .touchUpInside)
        
        self.rightView = button
        self.rightViewMode = UITextFieldViewMode.always
    }
}
