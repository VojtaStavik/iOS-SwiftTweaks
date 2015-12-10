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


public extension dispatch_once_t {

    public mutating func once(closure: () -> ()) {

        dispatch_once(&self) {

            closure()
        }
    }
}



// MARK: -

public func removeNotificationObserver(observer: AnyObject?) {

    if let observer = observer {

        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
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


public func degreesToRadians(degrees:Double) -> CGFloat
{
    return CGFloat((degrees * M_PI) / 180.0)
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
