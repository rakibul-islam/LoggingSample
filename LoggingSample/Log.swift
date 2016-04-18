//
//  Log.swift
//  JetLog
//
//  Created by Rakibul Islam on 4/7/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import Foundation

enum LogType: Int {
    case DEBUG = 0, INFO, WARNING, ERROR
}

class Log: NSObject, NSCoding {
   
    var logType: LogType
    var message: String
    var date: String
    var appendDate: Bool
    var showLogLevel: Bool
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let FileUrl = DocumentsDirectory.URLByAppendingPathComponent("logs")
    
    init(logType: LogType, message: String, appendDate: Bool, showLogLevel: Bool) {
        self.logType = logType
        self.message = message
        let currentDate = NSDate.init()
        self.date = currentDate.description
        self.appendDate = appendDate
        self.showLogLevel = showLogLevel
        
        super.init()
        
        if message.isEmpty {
            self.message = ""
        }
        
    }
    
    init(logMO: LogMO) {
        self.logType = LogType.init(rawValue: logMO.logType)!
        self.message = logMO.message!
        self.date = logMO.date!
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
            case .DEBUG:
                returnString = "DEBUG : " + returnString
            case .INFO:
                returnString = "INFO : " + returnString
            case .WARNING:
                returnString = "WARNING : " + returnString
            case .ERROR:
                returnString = "ERROR : " + returnString
            }
        }
        return returnString
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(message, forKey: "message")
        aCoder.encodeInteger(logType.rawValue, forKey: "LogType")
        aCoder.encodeBool(appendDate, forKey: "appendDate")
        aCoder.encodeBool(showLogLevel, forKey: "showLogLevel")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let message = aDecoder.decodeObjectForKey("message") as! String
        let logType = aDecoder.decodeIntegerForKey("LogType")
        let appendDate = aDecoder.decodeBoolForKey("appendDate")
        let showLogLevel = aDecoder.decodeBoolForKey("showLogLevel")
        self.init(logType: LogType.init(rawValue: logType)!, message: message, appendDate: appendDate, showLogLevel: showLogLevel)
        
    }
}