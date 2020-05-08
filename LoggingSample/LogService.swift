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
    case console, file, web, coreData
}

class LogService: NSObject {
    
    var logs = [Log]()
    var endpoint: LogServiceEndpoints
    var dataController: DataController!
    lazy var fileUrl: URL = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate, let url = delegate.applicationDocumentsDirectory.appendingPathComponent("logs") else {
            fatalError("something seriously wrong here")
        }
        return url
    }()
    
    init(endpoint: LogServiceEndpoints) {
        self.endpoint = endpoint
        super.init()
        if endpoint == .file {
            openFile()
        }
        else if endpoint == .coreData {
            getFromCoreData()
        }
    }
    
    func addLog(log: Log) {
        logs.append(log)
        switch endpoint {
        case .console:
            sendToConsole(log: log)
        case .file:
            sendToFile(log: log)
        case .web:
            sendToWeb(log: log)
        case .coreData:
            sendToCoreData(log: log)
        }
    }
    
    func sendToConsole(log: Log) {
        print(log.printLog())
    }
    
    func sendToFile(log: Log) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: logs, requiringSecureCoding: true)
            try data.write(to: fileUrl)
            print(data)
        } catch {
            print("Failed to save logs...\(error)")
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
        if endpoint == .file {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: logs, requiringSecureCoding: true)
                try data.write(to: fileUrl)
                print(data)
            } catch {
                print("Failed to save logs...\(error)")
            }
        }
        else if endpoint == .coreData {
            dataController.clearAllLogs()
        }
    }
    
    func openFile() {
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                let data = try Data(contentsOf: fileUrl)
                if let logArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Log] {
                    logs.append(contentsOf: logArray)
                }
            } catch {
                print("Failed to load logs...\(error)")
            }
        } else {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
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
