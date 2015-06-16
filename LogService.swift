//
//  LogService.swift
//
//  Created by Vojta Stavik on 17/02/15.
//  Copyright (c) 2015 STRV. All rights reserved.
//

import Foundation

let log = LogService()


class LogService {
    
    enum GeneralLogLevel {
        
        case Debug
        case Production
        case ProductionWithCrashlogs
    }
    
    
    var crashlogAction : ((text:String)->())? = nil
    
    var logLevel : GeneralLogLevel = .Debug
    
    
    func message(text: String, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {
        
        let filename = file.lastPathComponent.stringByDeletingPathExtension
        
        let messageText = "\n===============" + " \(filename).\(function)[\(line)]: \n " + text + "\n==============="
        
        if logLevel == .Debug {
            
            println(messageText)
        }
        
        if logLevel == .ProductionWithCrashlogs {
            
            crashlogAction?(text: messageText)
        }
    }
    
    
    func error(text: String, error: NSError?, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {

        let errorText = error?.description ?? "No NSError object"

        var messageText = "ERROR! \n Message: \(text) \n Error object: \(errorText)"
        
        self.message(messageText, file, function, line)
    }
}
