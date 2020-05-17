//
//  LogMO+CoreDataClass.swift
//  LoggingSample
//
//  Created by Rakibul Islam on 5/17/20.
//  Copyright © 2020 Rakibul Islam. All rights reserved.
//
//

import Foundation
import CoreData


public class LogMO: NSManagedObject {
    func printLog() -> String {
        var returnString = message ?? ""
        if appendDate, let date = date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            returnString = formatter.string(from: date) + " : " + returnString
        }
        if showLogLevel {
            switch LogType.init(raw64Value: logType) {
            case .debug:
                returnString = "DEBUG : " + returnString
            case .info:
                returnString = "INFO : " + returnString
            case .warning:
                returnString = "WARNING : " + returnString
            case .error:
                returnString = "ERROR : " + returnString
            case .none:
                break
            }
        }
        return returnString
    }
}
