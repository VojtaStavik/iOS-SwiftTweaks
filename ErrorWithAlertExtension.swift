//
//  ErrorExtension.swift
//  Matic
//
//  Created by Vojta Stavik on 16/04/15.
//  Copyright (c) 2015 STRV. All rights reserved.
//

import UIKit

extension LogService {
    
    func errorWithAlert(text: String, error: NSError?, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {
        
        showAlert("ERROR", text: error?.localizedDescription == nil ? text : error!.localizedDescription)
        self.error(text, error: error, file, function, line)
    }
    
    
    func showAlert(title: String, text: String) {
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        UIApplication.sharedApplication().keyWindow?.visibleViewController()?.presentViewController(alert, animated: true, completion: nil)
    }
}