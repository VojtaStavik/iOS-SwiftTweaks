//
//  LogService.swift
//
//  Created by Vojta Stavik on 17/02/15.
//  Copyright (c) 2015 STRV. All rights reserved.
//

import Foundation

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
}
