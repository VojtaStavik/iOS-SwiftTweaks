//
//  ErrorExtension.swift
//  Matic
//
//  Created by Vojta Stavik on 16/04/15.
//  Copyright (c) 2015 STRV. All rights reserved.
//

import UIKit

public extension LogService {
    
    public func errorWithAlert(text: String, error: NSError?, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {
        
        if #available(iOS 8.0, *) {
            showAlert("ERROR", text: error?.localizedDescription == nil ? text : error!.localizedDescription)
        }
        self.error(text, error: error, file, function, line)
    }
    
    

    @available(iOS 8.0, *)
    public func showAlert(title: String, text: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        UIApplication.sharedApplication().keyWindow?.visibleViewController()?.presentViewController(alert, animated: true, completion: nil)
        
        return alert
    }
}