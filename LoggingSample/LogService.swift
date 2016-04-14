//
//  LogService.swift
//  JetLog
//
//  Created by Rakibul Islam on 4/7/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import Foundation

enum LogServiceEndpoints {
    case CONSOLE, FILE, WEB, COREDATA
}

class LogService: NSObject {
    
    var logs = [Log]()
    var endpoint: LogServiceEndpoints
    
    init(endpoint: LogServiceEndpoints) {
        self.endpoint = endpoint
        super.init()
        if endpoint == .FILE {
            openFile()
        }
    }
    
    func addLog(log: Log) {
        logs.append(log)
        switch endpoint {
        case .CONSOLE:
            sendToConsole(log)
        case .FILE:
            sendToFile(log)
        case .WEB:
            sendToWeb(log)
        case .COREDATA:
            sendToCoreData(log)
        }
    }
    
    func sendToConsole(log: Log) {
        print(log.printLog())
    }
    
    func sendToFile(log: Log) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(logs, toFile: Log.FileUrl.path!)
        if !isSuccessfulSave {
            print("Failed to save logs...")
        }
    }
    
    func sendToWeb(log: Log) {
        print("call web service")
    }
    
    func sendToCoreData(log: Log) {
        print("save in CoreData")
    }
    
    func printAllLogs() {
        for log in logs {
            print(log.printLog())
        }
    }
    
    func printLogsOfType(logType: LogType) {
        for log in logs {
            if log.logType == logType {
                print(log.printLog())
            }
        }
    }
    
    func clearAllLogs() {
        logs.removeAll()
        if endpoint == .FILE {
            NSKeyedArchiver.archiveRootObject(logs, toFile: Log.FileUrl.path!)
        }
    }
    
    func openFile() {
        if let logArray = NSKeyedUnarchiver.unarchiveObjectWithFile(Log.FileUrl.path!) as? [Log] {
            logs.appendContentsOf(logArray)
        }
    }
}