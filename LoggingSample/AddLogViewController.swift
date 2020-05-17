//
//  AddLogViewController.swift
//  LoggingSample
//
//  Created by Rakibul Islam on 4/7/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit

class AddLogViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var appendDateSwitch: UISwitch!
    @IBOutlet weak var showLevelSwitch: UISwitch!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addButton: UIBarButtonItem!
    var logType: LogType?
    var log: Log?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if addButton.isEqual(sender) {
            let message = messageTextField.text ?? "No message"
            let selectedValue = typeSegmentedControl.selectedSegmentIndex
            log = Log(logType: LogType(rawValue: selectedValue) ?? .debug, message: message, appendDate: appendDateSwitch.isOn, showLogLevel: showLevelSwitch.isOn)
        }
    }
}

