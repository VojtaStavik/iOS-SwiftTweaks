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
        
        let messageText = "\(filename).\(function)[\(line)]: \n" + text + "\n ==============="
        
        if logLevel == .Debug {
            
            println(messageText)
        }
        
        if logLevel == .ProductionWithCrashlogs {
            
            crashlogAction?(text: messageText)
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
        
        
        var messageText = "\n ERROR! \n: Message: \(text) \n Error description: \(errorText)"
        
        self.message(messageText, file, function, line)
    }
}
