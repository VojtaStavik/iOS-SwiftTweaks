//
//  LogService.swift
//
//  Created by Vojta Stavik
//  Copyright (c) 2015 STRV. All rights reserved.
//

import Foundation

public typealias ExternalLogAction = (text: String) -> Void

public class LogService {

    public static let sharedService = LogService()

    public enum GeneralLogLevel {

        case Debug
        case Production
        case ProductionWithCrashlogs
    }


    // We use this because of nice readible syntax :
    //  log.message("Test remote")(.RemoteLogging)
    //  log.message("Text local")

    public enum ExternalLogActions {

        case RemoteLogging
        case None
    }

    public var crashLogAction:     ExternalLogAction? = nil
    public var messageLogAction:   ExternalLogAction? = nil
    public var errorLogAction:     ExternalLogAction? = nil

    public var logLevel : GeneralLogLevel = .Debug


    typealias Message = String -> String

    private func detailedMessage(file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) -> Message {

        return { text -> String in

            let filename = NSURL(string: file)?.URLByDeletingPathExtension?.lastPathComponent

            let messageText = "\n===============" + " \(filename).\(function)[\(line)]: \n " + text + "\n==============="

            return messageText
        }
    }

    public func message(text: String, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) -> (ExternalLogActions -> Void)! {

        let message = detailedMessage(file, function, line)


        if logLevel == .Debug {

            print(message(text))
        }


        if logLevel == .ProductionWithCrashlogs {

            crashLogAction?(text: message(text))
        }


        return { externalLogAction -> Void in

            if externalLogAction == .RemoteLogging { self.messageLogAction?(text: message(text)) }
        }
    }

    public func error(text: String, error: NSError?, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) -> (ExternalLogActions -> Void)! {

        let errorText = error?.description ?? "No NSError object"

        let messageText = "ERROR! \n Message: \(text) \n Error object: \(errorText)"

        message(messageText, file, function, line)

        return { externalLogAction -> Void in

            if externalLogAction == .RemoteLogging { self.errorLogAction?(text: self.detailedMessage(file, function, line)(messageText)) }
        }
    }
}
