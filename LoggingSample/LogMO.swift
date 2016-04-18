//
//  LogMO.swift
//  LoggingSample
//
//  Created by Rakibul Islam on 4/15/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit
import CoreData

class LogMO: NSManagedObject {
    @NSManaged var logType: Int
    @NSManaged var message: String?
    @NSManaged var date: String?
    @NSManaged var appendDate: Bool
    @NSManaged var showLogLevel: Bool
}
