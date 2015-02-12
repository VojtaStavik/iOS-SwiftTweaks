//
//  SwiftTweaks.swift
//  Wiretap
//
//  Created by Vojta Stavik on 27/01/15.
//  Copyright (c) 2015 Vojtech Stavik. All rights reserved.
//

import Foundation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


func RGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor! {
    
    return RGBA(red, green, blue, 1)
}


func RGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor! {
    
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)

}

