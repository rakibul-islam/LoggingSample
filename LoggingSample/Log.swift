//
//  Log.swift
//  LoggingSample
//
//  Created by Rakibul Islam on 4/7/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import Foundation

enum LogType: Int {
    case debug = 0, info, warning, error
    
    init?(raw64Value: Int64) {
        self.init(rawValue: Int(raw64Value))
    }
}

class Log: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
   
    var logType: LogType
    var message: String
    var date: Date
    var appendDate: Bool
    var showLogLevel: Bool
    
    init(logType: LogType, message: String, date: Date? = nil, appendDate: Bool, showLogLevel: Bool) {
        self.logType = logType
        self.message = message
        self.date = date ?? Date()
        self.appendDate = appendDate
        self.showLogLevel = showLogLevel
        
        super.init()
        
        if message.isEmpty {
            self.message = ""
        }
        
    }
    
    func printLog() -> String {
        var returnString = message
        if appendDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            returnString = formatter.string(from: date) + " : " + returnString
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
        coder.encode(date, forKey: "date")
        coder.encode(logType.rawValue, forKey: "LogType")
        coder.encode(appendDate, forKey: "appendDate")
        coder.encode(showLogLevel, forKey: "showLogLevel")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let message = aDecoder.decodeObject(forKey: "message") as? String ?? ""
        let logType = aDecoder.decodeInteger(forKey: "LogType")
        let date = aDecoder.decodeObject(forKey: "date") as? Date
        let appendDate = aDecoder.decodeBool(forKey: "appendDate")
        let showLogLevel = aDecoder.decodeBool(forKey: "showLogLevel")
        self.init(logType: LogType(rawValue: logType) ?? .debug, message: message, date: date, appendDate: appendDate, showLogLevel: showLogLevel)
        
    }
}
