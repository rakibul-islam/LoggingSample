//
//  MainTableViewController.swift
//  JetLog
//
//  Created by Rakibul Islam on 4/8/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    var consoleLog : LogService!
    var fileLog : LogService!
    var webLog : LogService!
    var dataLog : LogService!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 4
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        switch indexPath.row {
        case 1:
            cell.textLabel?.text = "File"
            break
        case 2:
            cell.textLabel?.text = "Web"
            break
        case 3:
            cell.textLabel?.text = "CoreData"
            break
        default:
            cell.textLabel?.text = "Console"
            break;
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToConsole" {
            let secondTableVC = segue.destinationViewController as! SecondTableViewController
            let selectedIndex = tableView.indexPathForSelectedRow!.row
            switch selectedIndex {
            case 1:
                if fileLog == nil {
                    fileLog = LogService.init(endpoint: LogServiceEndpoints.FILE)
                }
                secondTableVC.logService = fileLog
            case 2:
                if webLog == nil {
                    webLog = LogService.init(endpoint: LogServiceEndpoints.WEB)
                }
                secondTableVC.logService = webLog
                
            case 3:
                if dataLog == nil {
                    dataLog = LogService.init(endpoint: LogServiceEndpoints.COREDATA)
                }
                secondTableVC.logService = dataLog
            default:
                if consoleLog == nil {
                    consoleLog = LogService.init(endpoint: LogServiceEndpoints.CONSOLE)
                }
                secondTableVC.logService = consoleLog
            }
        }
    }
    

}
