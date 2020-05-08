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
        guard let modelURL = Bundle.main.url(forResource: "LoggingSample", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        DispatchQueue.global(qos: .background).async() {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docUrl = urls[urls.endIndex - 1]
            let storeURL = docUrl.appendingPathComponent("LoggingSample.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            }
            catch {
                fatalError("Error migrating store: \(error)")
            }
        }
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
            let fetchedLogs = try managedObjectContext.fetch(logFetch) as! [LogMO]
            returnLogs += fetchedLogs
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
