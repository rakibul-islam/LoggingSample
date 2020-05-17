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
        let logMO = NSEntityDescription.insertNewObject(forEntityName: "Log", into: managedObjectContext) as! LogMO
        logMO.logType = Int64(log.logType.rawValue)
        logMO.message = log.message
        logMO.date = log.date
        logMO.appendDate = log.appendDate
        logMO.showLogLevel = log.showLogLevel
        do {
            try managedObjectContext.save()
        }
        catch {
            debugPrint("Failure to save context: \(error)")
        }
    }
    
    func getLogs() -> [LogMO] {
        let logFetch = NSFetchRequest<LogMO>(entityName: "Log")
        var returnLogs = [LogMO]()
        do {
            let fetchedLogs = try managedObjectContext.fetch(logFetch)
            returnLogs += fetchedLogs
        }
        catch {
            debugPrint("Failed to fetch logs: \(error)")
        }
        return returnLogs
    }
    
    func deleteLog(log: LogMO) {
        guard let date = log.date as NSDate? else { return }
        let logFetch = NSFetchRequest<LogMO>(entityName: "Log")
        logFetch.predicate = NSPredicate(format: "date == %@", date)
        do {
            let fetchedLogs = try managedObjectContext.fetch(logFetch)
            fetchedLogs.forEach({ managedObjectContext.delete($0) })
            try managedObjectContext.save()
        } catch {
            debugPrint("Failed to delete logs: \(error)")
        }
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
            debugPrint("Failure to save context: \(error)")
        }
    }
    
}
