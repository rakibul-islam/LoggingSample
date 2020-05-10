//
//  DataController.swift
//  LoggingSample
//
//  Created by Rakibul Islam on 4/15/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    var persistentContainer: NSPersistentContainer
    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    init(container: NSPersistentContainer) {
        persistentContainer = container
    }
    
    override convenience init() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Something wrong here!")
        }
        self.init(container: delegate.persistentContainer)
    }
    
    func addLog(log: Log) {
        let logMO = NSEntityDescription.insertNewObject(forEntityName: "Log", into: self.managedObjectContext) as! LogMO
        logMO.logType = log.logType.rawValue
        logMO.message = log.message
        logMO.date = log.date
        logMO.appendDate = log.appendDate
        logMO.showLogLevel = log.showLogLevel
        do {
            try managedObjectContext.save()
        }
        catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func getLogs() -> [LogMO] {
        let logFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Log")
        var returnLogs = [LogMO]()
        do {
            if let fetchedLogs = try managedObjectContext.fetch(logFetch) as? [LogMO] {
                returnLogs += fetchedLogs
            }
        }
        catch {
            debugPrint("Failed to fetch logs: \(error)")
        }
        return returnLogs
    }
    
    func clearAllLogs() {
        let logs = getLogs()
        for logMO in logs {
            managedObjectContext.delete(logMO)
        }
        do {
            try managedObjectContext.save()
        }
        catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
}
