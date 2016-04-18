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
    
    var managedObjectContext: NSManagedObjectContext
    override init() {
        guard let modelURL = NSBundle.mainBundle().URLForResource("LoggingSample", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { 
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docUrl = urls[urls.endIndex - 1]
            let storeURL = docUrl.URLByAppendingPathComponent("LoggingSample.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            }
            catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    func addLog(log: Log) {
        let logMO = NSEntityDescription.insertNewObjectForEntityForName("Log", inManagedObjectContext: self.managedObjectContext) as! LogMO
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
        let logFetch = NSFetchRequest(entityName: "Log")
        var returnLogs = [LogMO]()
        do {
            let fetchedLogs = try managedObjectContext.executeFetchRequest(logFetch) as! [LogMO]
            returnLogs += fetchedLogs
        }
        catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        return returnLogs
    }
    
    func clearAllLogs() {
        let logs = getLogs()
        for logMO in logs {
            managedObjectContext.deleteObject(logMO)
        }
        do {
            try managedObjectContext.save()
        }
        catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
}
