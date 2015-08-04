//
//  LogService.swift
//
//  Created by Vojta Stavik
//  Copyright (c) 2015 STRV. All rights reserved.
//

import Foundation

let log = LogService()

typealias ExternalLogAction = (text: String) -> Void

class LogService {
    
    enum GeneralLogLevel {
        
        case Debug
        case Production
        case ProductionWithCrashlogs
    }
    
    
    // We use this because of nice readible syntax :
    //  log.message("Test remote")(.RemoteLogging)
    //  log.message("Text local")
    
    enum ExternalLogActions {
        
        case RemoteLogging
        case None
    }
    
    
    var crashLogAction:     ExternalLogAction? = nil
    var messageLogAction:   ExternalLogAction? = nil
    var errorLogAction:     ExternalLogAction? = nil
    
    var logLevel : GeneralLogLevel = .Debug
    
    
    typealias Message = String -> String
    
    private func detailedMessage(_ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) -> Message {
        
        return { text -> String in
            
            let filename = file.lastPathComponent.stringByDeletingPathExtension
            
            let messageText = "\n===============" + " \(filename).\(function)[\(line)]: \n " + text + "\n==============="
            
            return messageText
        }
    }
    
    
    func message(text: String, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) -> (ExternalLogActions -> Void)! {
        
        let message = detailedMessage(file, function, line)
        
        
        if logLevel == .Debug {
            
            println(message(text))
        }
        
        
        if logLevel == .ProductionWithCrashlogs {
            
            crashLogAction?(text: message(text))
        }
        
        
        return { externalLogAction -> Void in
            
            if externalLogAction == .RemoteLogging { self.messageLogAction?(text: message(text)) }
        }
    }
    
    
    func error(text: String, error: NSError?, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) -> (ExternalLogActions -> Void)! {
        
        let errorText = error?.description ?? "No NSError object"
        
        var messageText = "ERROR! \n Message: \(text) \n Error object: \(errorText)"
        
        message(messageText, file, function, line)
        
        return { externalLogAction -> Void in
            
            if externalLogAction == .RemoteLogging { self.errorLogAction?(text: self.detailedMessage(file, function, line)(messageText)) }
        }
    }
}
