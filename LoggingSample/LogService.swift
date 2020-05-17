//
//  LogService.swift
//  LoggingSample
//
//  Created by Rakibul Islam on 4/7/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit
import CoreData

enum LogServiceEndpoints {
    case console, file, web, coreData
    
    var name: String {
        switch self {
        case .console:
            return "Console"
        case .file:
            return "File"
        case .web:
            return "Web"
        case .coreData:
            return "CoreData"
        }
    }
}

class LogService: NSObject {
    
    var logs: [Log] = []
    var endpoint: LogServiceEndpoints
    lazy var dataController = DataController()
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
    }
    
    func addLog(log: Log) {
        if endpoint == .coreData {
            sendToCoreData(log: log)
            return
        }
        logs.append(log)
        switch endpoint {
        case .console:
            sendToConsole(log: log)
        case .file:
            sendToFile()
        case .web:
            sendToWeb(log: log)
        default:
            break
        }
    }
    
    func deleteLog(log: Any?) {
        if let logMO = log as? LogMO {
            dataController.deleteLog(log: logMO)
        } else if let log = log as? Log {
            deleteLog(log: log)
        }
    }
    
    private func deleteLog(log: Log) {
        if let index = logs.firstIndex(of: log) {
            logs.remove(at: index)
            switch endpoint {
            case .file:
                sendToFile()
            default:
                break
            }
        }
    }
    
    func sendToConsole(log: Log) {
        print(log.printLog())
    }
    
    func sendToFile() {
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
        for log in logs where log.logType == logType {
            print(log.printLog())
        }
    }
    
    func clearAllLogs() {
        logs.removeAll()
        if endpoint == .file {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: logs, requiringSecureCoding: true)
                try data.write(to: fileUrl)
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
}
