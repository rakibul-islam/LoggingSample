//
//  SecondTableViewController.swift
//  JetLog
//
//  Created by Rakibul Islam on 4/8/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit

class SecondTableViewController: UITableViewController {
    var logService : LogService!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        switch logService.endpoint {
            case .CONSOLE:
                navigationItem.title = "Console Log"
            case .COREDATA:
                navigationItem.title = "Core Data Log"
            case .FILE:
                navigationItem.title = "File Log"
            case .WEB:
                navigationItem.title = "Web Log"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logService.logs.count + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("secondCellIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        if indexPath.row == logService.logs.count {
            cell.textLabel?.text = "Clear Logs"
        }
        else {
            let log = logService.logs[indexPath.row]
            cell.textLabel?.text = log.printLog()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == logService.logs.count {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            logService.clearAllLogs()
            let alertController = UIAlertController(title: "Success", message: "All Logs Cleared!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (self) in
                tableView.reloadData()
            }))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ViewController, log = sourceViewController.log{
            logService.addLog(log)
            tableView.reloadData()
        }
    }
}
