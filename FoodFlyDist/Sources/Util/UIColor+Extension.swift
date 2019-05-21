//
//  UIColor+Extension.swift
//  FoodFlyDist
//
//  Created by Seungjin on 21/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Cocoa

extension NSColor {
    
    class func RGB(red:CGFloat, green:CGFloat, blue:CGFloat) -> NSColor {
        return self.RGBA(red: red, green: green, blue: blue, alpha: 1);
    }
    
    class func RGBA(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) -> NSColor {
        return NSColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha);
    }
    
    class func RGBHex(hexValue:Int) -> NSColor {
        return self.RGB(red: (CGFloat)((hexValue & 0xFF0000) >> 16),
                        green: (CGFloat)((hexValue & 0xFF00) >> 8),
                        blue: (CGFloat)((hexValue & 0xFF)));
    }
    
    class func RGBAHex(hexValue:UInt) -> NSColor {
        return self.RGBA(red: (CGFloat)((hexValue & 0xFF000000) >> 24),
                         green: (CGFloat)((hexValue & 0xFF0000) >> 16),
                         blue: (CGFloat)((hexValue & 0xFF00) >> 8),
                         alpha: (CGFloat)((hexValue & 0xFF)))
    }
}
