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
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logService.logs.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "secondCellIdentifier", for: indexPath)

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == logService.logs.count {
            tableView.deselectRow(at: indexPath, animated: true)
            logService.clearAllLogs()
            let alertController = UIAlertController(title: "Success", message: "All Logs Cleared!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (self) in
                tableView.reloadData()
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let log = sourceViewController.log {
            logService.addLog(log: log)
            tableView.reloadData()
        }
    }
}
