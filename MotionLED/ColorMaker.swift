//
//  ColorMaker.swift
//  MotionLED
//
//  Created by youringtone on 2016/03/07.
//  Copyright © 2016年 youringtone. All rights reserved.
//

import UIKit




class ColorMaker: UIColor {
    var color:UIColor!
//    var switch_R:Bool!
//    
    
    
    
    
    
    override init() {
        super.init()
        
        let red = UIColor.redColor().CGColor
    
    }
    
    
    
    
    
    

    required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
