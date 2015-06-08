//
//  SwiftTweaks.swift
//
//  Created by Vojta Stavik on 27/01/15.
//  Copyright (c) 2015 Vojtech Stavik. All rights reserved.
//

import Foundation
import UIKit

let kNavigationBarHeight : CGFloat = 64


func delay(delay:Double,closure:  ()->()) {

    dispatch_after(
    
        dispatch_time(
        
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),

        dispatch_get_main_queue(), closure)
}


func between<T : Comparable>(minimum: T, maximum: T, value: T) -> T {
    
    return min( max(minimum, value) , maximum)
}


func repeat(cycles: Int, closure: () -> ()) {
    
    for _ in 0..<cycles {
        
        closure()
    }
}


func randomStringWithLength (len : Int) -> String {
    
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    var randomString = ""
    
    repeat(len) {
        
        let rand = Int(arc4random_uniform(UInt32(count(letters))))
        randomString.append(letters[rand])
    }

    return randomString
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


func RGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor! {
    
    return RGBA(red, green, blue, 1)
}


func RGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor! {
    
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}




// MARK: - Extensions

extension String {

    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }

    func isValidEmail() -> Bool {

        let regex = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive, error: nil)
        
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
    }
}


extension UINavigationController {
    
    var rootViewController: UIViewController {
        
        return self.viewControllers.first as! UIViewController
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
        
        if let index = index {

            self.removeAtIndex(index)
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


extension UICollectionReusableView {
    
    class func reusableIdentifier() -> String! {
        
        return NSStringFromClass(self) + "Identifier"
    }
}


extension UITableViewCell {
    
    class func reusableIdentifier() -> String! {
        
        return NSStringFromClass(self) + "Identifier"
    }
}


extension UIImage {
	
    /**
    Returns image with size 1x1px of certain color.
    */
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

    /**
    Returns current image colored to certain color.
    */
    func imageWithColor(color: UIColor) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)

        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextClipToMask(context, rect, self.CGImage)
        color.setFill()
        CGContextFillRect(context, rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
        return newImage;
    }
}


extension UIColor {
    
    convenience init(hexString: String) {
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hexString.hasPrefix("#") {
            
            let index   = advance(hexString.startIndex, 1)
            let hex     = hexString.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexLongLong(&hexValue) {
                
                switch (count(hex)) {
                    
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                    
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                    
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                    
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                    
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                    
                }
                
            } else {
                
                println("Scan hex error")
            }
            
        } else {
            
            print("Invalid RGB string, missing '#' as prefix")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    
    class func colorWithHexString (hex:String) -> UIColor {

        return UIColor(hexString: hex)
    }
}


extension UIWindow {

    func visibleViewController() -> UIViewController? {
    
        if let rootViewController: UIViewController  = self.rootViewController {
        
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }

        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if vc.isKindOfClass(UINavigationController.self) {
            
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( navigationController.visibleViewController)
        }
        
        else if vc.isKindOfClass(UITabBarController.self) {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)
            
        }
        
        else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(presentedViewController)
                
            } else {
                
                return vc
            }
        }
    }
}

    
extension UINavigationController {
    
    func setTransparentNavigationBar() {
        
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.translucent = true
    }
}


extension UICollectionView {
    
    var currentPageNumber: Int {
        
        return Int(ceil(self.contentOffset.x / self.frame.size.width))
    }
}
