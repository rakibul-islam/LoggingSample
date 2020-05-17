//
//  SecondTableViewController.swift
//  LoggingSample
//
//  Created by Rakibul Islam on 4/8/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit
import CoreData

class SecondTableViewController: UIViewController {
    var logService : LogService!
    var fetchedResultsController: NSFetchedResultsController<LogMO>?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if logService.endpoint == .coreData {
            let context = logService.dataController.managedObjectContext
            let fetchRequest = NSFetchRequest<LogMO>(entityName: "Log")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = self
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                fatalError("Failed to fetch entities: \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch logService.endpoint {
            case .console:
                navigationItem.title = "Console Log"
            case .coreData:
                navigationItem.title = "Core Data Log"
            case .file:
                navigationItem.title = "File Log"
            case .web:
                navigationItem.title = "Web Log"
        }
    }
    
    @IBAction func clearLogsTapped(_ sender: Any) {
        logService.clearAllLogs()
        let alertController = UIAlertController(title: "Success", message: "All Logs Cleared!", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.tableView.reloadData()
        }))
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source
}

extension SecondTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController?.sections {
            return sections.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = fetchedResultsController?.sections?[section] {
            return sectionInfo.numberOfObjects
        }
        return logService.logs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "secondCellIdentifier") ??
            UITableViewCell(style: .default, reuseIdentifier: "secondCellIdentifier")

        // Configure the cell...
        if let log = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = log.printLog()
        } else {
            let log = logService.logs[indexPath.row]
            cell.textLabel?.text = log.printLog()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        if let log = fetchedResultsController?.object(at: indexPath) {
            logService.deleteLog(log: log)
        } else {
            let log = logService.logs[indexPath.row]
            logService.deleteLog(log: log)
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddLogViewController, let log = sourceViewController.log {
            logService.addLog(log: log)
            tableView.reloadData()
        }
    }
}

extension SecondTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
