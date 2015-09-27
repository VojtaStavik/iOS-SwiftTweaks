//
//  SwiftTweaks.swift
//
//  Created by Vojta Stavik
//  Copyright (c) 2015 Vojtech Stavik. All rights reserved.
//

import Foundation
import UIKit

public let kNavigationBarHeight : CGFloat = 64


// MARK: -

public func delay(delay:Double,closure:  ()->())
{
    dispatch_after(
        
        dispatch_time(
            
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        
        dispatch_get_main_queue(), closure)
}


public func backgroundQueue(closure:  ()->())
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), closure)
}


public func mainQueue(closure:  ()->())
{
    dispatch_async(dispatch_get_main_queue(), closure)
}


// MARK: -

public func cycle(times: Int, closure: () -> ())
{
    for _ in 0..<times
        {
            closure()
        }
}


public func between<T : Comparable>(minimum: T, maximum: T, value: T) -> T
{
    return min( max(minimum, value) , maximum)
}



// MARK: -

public func randomStringWithLength (len : Int) -> String
{
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    var randomString = ""
    
    cycle(len)
        {
            let rand = Int(arc4random_uniform(UInt32(letters.characters.count)))
            randomString.append(letters[rand])
        }
    
    return randomString
}


public func printAllAvailableFonts()
{
    
    let fontFamilyNames = UIFont.familyNames()
    
    for familyName in fontFamilyNames
        {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName )
            print("Font Names = [\(names)]")
        }
}


public func RGB(red: CGFloat,_ green: CGFloat,_ blue: CGFloat) -> UIColor!
{
    return RGBA(red, green, blue, 1)
}


public func RGBA(red: CGFloat,_ green: CGFloat,_ blue: CGFloat,_ alpha: CGFloat) -> UIColor!
{
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}




// MARK: - Extensions

public extension String
{
    public subscript (i: Int) -> Character
    {
        return self[self.startIndex.advancedBy(i) ]
    }
    
    public subscript (i: Int) -> String
    {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String
    {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
    
    public func isValidEmail() -> Bool
    {
        
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [NSRegularExpressionOptions.CaseInsensitive])
        
        return regex?.firstMatchInString(self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
    
    public var isNotEmpty: Bool
    {
        return !isEmpty
    }
}


public extension UITextField
{
    public var isEmpty: Bool
    {
        return text?.isEmpty ?? true
    }
    
    public var isNotEmpty: Bool
    {
        return !isEmpty
    }
}


public extension UINavigationController
{
    public var rootViewController: UIViewController
    {
        return self.viewControllers.first!
    }
}


public extension Array
{
    
    public var isEmpty : Bool
    {
        return count == 0
    }

    public var isNotEmpty : Bool
        {
            return !isEmpty
    }
    
    public mutating func removeObject<U: Equatable>(object: U)
    {
        var index: Int?
        
        for (idx, objectToCompare) in self.enumerate()
            {
                if let to = objectToCompare as? U
                {
                    if object == to
                    {
                        index = idx
                    }
                }
            }
        
        if let index = index
        {
            self.removeAtIndex(index)
        }
    }
}


public extension UIScreen
{
    public class func screenWidth() -> CGFloat!
    {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    public class func screenHeight() -> CGFloat!
    {
        return UIScreen.mainScreen().bounds.size.height
    }
}


public extension UICollectionReusableView
{
    static public var reusableIdentifier : String
    {
        return NSStringFromClass(self) + "Identifier"
    }
}


public extension UITableViewCell
{    
    static public var reusableIdentifier : String {
        
        return NSStringFromClass(self) + "Identifier"
    }
}


public extension UIImage 
{
    
    /**
    Returns image with size 1x1px of certain color.
    */
    public class func imageWithColor(color : UIColor) -> UIImage 
    {
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
    @available(*, deprecated, message="Use similar build-in XCAssetCatalog functionality.")
    public func imageWithColor(color: UIColor) -> UIImage 
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        
        CGContextSetBlendMode(context, .Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextClipToMask(context, rect, self.CGImage)
        color.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage;
    }
}


public extension UIColor 
{
    public convenience init(hexString: String) 
    {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hexString.hasPrefix("#") 
        {
            let index   = hexString.startIndex.advancedBy(1)
            let hex     = hexString.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexLongLong(&hexValue) 
            {
                switch (hex.characters.count) 
                {
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
                
                print("Scan hex error")
            }
            
        } else {
            
            print("Invalid RGB string, missing '#' as prefix")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    
    public class func colorWithHexString (hex:String) -> UIColor 
    {
        return UIColor(hexString: hex)
    }
}


public extension UIWindow 
{
    public func visibleViewController() -> UIViewController? 
    {
        if let rootViewController: UIViewController  = self.rootViewController 
        {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }
        
        return nil
    }
    
    public class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController 
    {
        if let navigationController = vc as? UINavigationController 
        {
            return UIWindow.getVisibleViewControllerFrom(navigationController.visibleViewController!)
        
        } else if let tabBarController = vc as? UITabBarController {
            
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)
            
        } else if let
            pageViewController = vc as? UIPageViewController,
            currentVC = pageViewController.viewControllers?.first
        {
            return UIWindow.getVisibleViewControllerFrom(currentVC)
        
        } else {
            
            if let presentedViewController = vc.presentedViewController 
            {
                return UIWindow.getVisibleViewControllerFrom(presentedViewController)
                
            } else {
                
                return vc
            }
        }
    }
}


public extension UINavigationController 
{
    public func setTransparentNavigationBar() 
    {
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.translucent = true
    }
}


public extension UICollectionView 
{
    public var currentPageNumber: Int 
    {
        return Int(ceil(self.contentOffset.x / self.frame.size.width))
    }
}
