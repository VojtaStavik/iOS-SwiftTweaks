//
//  SwiftTweaks.swift
//
//  Created by Vojta Stavik on 27/01/15.
//  Copyright (c) 2015 Vojtech Stavik. All rights reserved.
//

import Foundation
import UIKit

let kNavigationBarHeight : CGFloat = 64


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


func between<T : Comparable>(minimum: T, maximum: T, value: T) -> T {
    
    return min( max(minimum, value) , maximum)
}


func randomStringWithLength (len : Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    var randomString : NSMutableString = NSMutableString(capacity: len)
    
    for (var i=0; i < len; i++){
        var length = UInt32 (letters.length)
        var rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }
    
    return randomString.copy() as! String
}


func printAllAvailableFonts() {
    
    let fontFamilyNames = UIFont.familyNames()

    for familyName in fontFamilyNames {
        
        println("------------------------------")
        println("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNamesForFamilyName(familyName as! String)
        println("Font Names = [\(names)]")
    }
}


// MARK: - Extensions

extension String {
    
    var uppercaseString : String {
        
        return (self as NSString).uppercaseString
    }
}


extension Array {

    mutating func removeObject<U: Equatable>(object: U) {
    
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
        
            if let to = objectToCompare as? U {
            
                if object == to {
                
                    index = idx
                }
            }
        }
        
        if index != nil {

            self.removeAtIndex(index!)
        }
    }
}


extension UIScreen {
    
    class func screenWidth() -> CGFloat! {
        
        return UIScreen.mainScreen().bounds.size.width
    }
    
    class func screenHeight() -> CGFloat! {
        
        return UIScreen.mainScreen().bounds.size.height
    }
}


extension UITableViewCell {
    
    class func reusableIdentifier() -> String! {
        
        return NSStringFromClass(self) + "Identifier"
    }
}


extension UICollectionViewCell {
    
    class func reusableIdentifier() -> String! {
        
        return NSStringFromClass(self) + "Identifier"
    }
}

extension UIImage {
	
	class func imageWithColor(color : UIColor) -> UIImage {
		
		let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
		
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, rect)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
		
	}
}
