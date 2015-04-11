//
//  LogService.swift
//
//  Created by Vojta Stavik on 17/02/15.
//  Copyright (c) 2015 STRV. All rights reserved.
//

import UIKit

let log = LogService()


enum LogLevel {
    
    case Debug
    case Production
    case ProductionWithCrashlogs
}

class LogService {
    
    var sendLogToCrashLogServiceAction : ((text:String)->())? = nil
    
    var ErrorDomain: String = "DefaultDomainError"
    
    var logLevel : LogLevel = .Debug
    
    
    func message(text: String) {
        
        if logLevel == .Debug {
            
            println(text)
        }
        
        if logLevel == .ProductionWithCrashlogs {
            
            sendLogToCrashLogServiceAction?(text: text)
        }
    }
    
    
    func error(text: String, error: NSError?, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {

        let errorText : String
        
        if let error = error {
            
            errorText = error.description
        }
        
        else {
            
            errorText = "No NSError object"
        }
        
        
        let filename = file.lastPathComponent.stringByDeletingPathExtension
        
        var messageText = "\n ERROR! \n \(filename).\(function)[\(line)]: \n Message: \(text) \n Error description: \(errorText)"
        
        self.message(messageText)
    }
    
    
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
