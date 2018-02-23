//
//  UIColorExtension.swift
//  TechnicalTest
//
//  Created by AT on 23/02/18.
//  Copyright © 2018 UbiqueSystems. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorWithHEXCode(hexStr: String, alpha: CGFloat) -> UIColor {
        
        var cString: String = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexStr.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if cString.isEmpty || cString.count != 6 {
            return colorWithRGB(rgbValue: 0xFF5300, alpha: alpha)
        } else {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            return colorWithRGB(rgbValue: rgbValue, alpha: alpha)
        }
    }
    
    class func colorWithRGB(rgbValue: UInt32, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
