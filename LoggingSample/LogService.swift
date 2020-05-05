//
//  LogService.swift
//  JetLog
//
//  Created by Rakibul Islam on 4/7/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit
import CoreData

enum LogServiceEndpoints {
    case CONSOLE, FILE, WEB, COREDATA
}

class LogService: NSObject {
    
    var logs = [Log]()
    var endpoint: LogServiceEndpoints
    var dataController: DataController!
    
    init(endpoint: LogServiceEndpoints) {
        self.endpoint = endpoint
        super.init()
        if endpoint == .FILE {
            openFile()
        }
        else if endpoint == .COREDATA {
            getFromCoreData()
        }
    }
    
    func addLog(log: Log) {
        logs.append(log)
        switch endpoint {
        case .CONSOLE:
            sendToConsole(log: log)
        case .FILE:
            sendToFile(log: log)
        case .WEB:
            sendToWeb(log: log)
        case .COREDATA:
            sendToCoreData(log: log)
        }
    }
    
    func sendToConsole(log: Log) {
        print(log.printLog())
    }
    
    func sendToFile(log: Log) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(logs, toFile: Log.FileUrl.path)
        if !isSuccessfulSave {
            print("Failed to save logs...")
        }
    }
    
    func sendToWeb(log: Log) {
        print("call web service")
    }
    
    func sendToCoreData(log: Log) {
        print("save in CoreData")
        dataController.addLog(log: log)
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
            NSKeyedArchiver.archiveRootObject(logs, toFile: Log.FileUrl.path)
        }
        else if endpoint == .COREDATA {
            dataController.clearAllLogs()
        }
    }
    
    func openFile() {
        if let logArray = NSKeyedUnarchiver.unarchiveObject(withFile: Log.FileUrl.path) as? [Log] {
            logs.append(contentsOf: logArray)
        }
    }
    
    func getFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        let logArray = dataController.getLogs()
        for logMO in logArray {
            let log = Log(logMO: logMO)
            logs.append(log)
        }
    }
}
