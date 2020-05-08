//
//  Log.swift
//  JetLog
//
//  Created by Rakibul Islam on 4/7/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import Foundation

enum LogType: Int {
    case debug = 0, info, warning, error
}

class Log: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
   
    var logType: LogType
    var message: String
    var date: String
    var appendDate: Bool
    var showLogLevel: Bool
    
    init(logType: LogType, message: String, appendDate: Bool, showLogLevel: Bool) {
        self.logType = logType
        self.message = message
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        self.date = formatter.string(from: currentDate)
        self.appendDate = appendDate
        self.showLogLevel = showLogLevel
        
        super.init()
        
        if message.isEmpty {
            self.message = ""
        }
        
    }
    
    init(logMO: LogMO) {
        self.logType = LogType(rawValue: logMO.logType) ?? .debug
        self.message = logMO.message ?? ""
        self.date = logMO.date ?? ""
        self.appendDate = logMO.appendDate
        self.showLogLevel = logMO.showLogLevel
        
        super.init()
    }
    
    func printLog() -> String {
        var returnString = message
        if appendDate {
            returnString = date + " : " + returnString
        }
        if showLogLevel {
            switch logType {
            case .debug:
                returnString = "DEBUG : " + returnString
            case .info:
                returnString = "INFO : " + returnString
            case .warning:
                returnString = "WARNING : " + returnString
            case .error:
                returnString = "ERROR : " + returnString
            }
        }
        return returnString
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(message, forKey: "message")
        coder.encode(logType.rawValue, forKey: "LogType")
        coder.encode(appendDate, forKey: "appendDate")
        coder.encode(showLogLevel, forKey: "showLogLevel")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let message = aDecoder.decodeObject(forKey: "message") as! String
        let logType = aDecoder.decodeInteger(forKey: "LogType")
        let appendDate = aDecoder.decodeBool(forKey: "appendDate")
        let showLogLevel = aDecoder.decodeBool(forKey: "showLogLevel")
        self.init(logType: LogType.init(rawValue: logType)!, message: message, appendDate: appendDate, showLogLevel: showLogLevel)
        
    }
}
