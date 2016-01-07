//
//  ErrorExtension.swift
//  Matic
//
//  Created by Vojta Stavik on 16/04/15.
//  Copyright (c) 2015 STRV. All rights reserved.
//

import UIKit

// If you want to use swift tweaks with extension, set the EXTENSION flag to TRUE

#if !EXTENSION
    
    @available(iOS 8.0, *)
    public extension LogService {
        
        public func errorWithAlert(text: String, error: NSError?, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {
            showAlert("ERROR", text: error?.localizedDescription ?? text)
            self.error(text, error: error, file, function, line)
        }
        
        public func showAlert(title: String, text: String, alert: UIAlertController? = nil) -> UIAlertController {
            
            let alertToShow : UIAlertController
            
            if let alert = alert {
                alertToShow = alert
            } else {
                let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                alertToShow = alert
            }
            
            delay(0.1) { [weak self] in
                if let topVC = UIApplication.sharedApplication().keyWindow?.visibleViewController() where topVC.isBeingDismissed() == false {
                    topVC.presentViewController(alertToShow, animated: true, completion: nil)
                } else {
                    self?.showAlert(title, text: text, alert: alertToShow)
                }
            }
            
            return alertToShow
        }
    }
    
    
#endif
