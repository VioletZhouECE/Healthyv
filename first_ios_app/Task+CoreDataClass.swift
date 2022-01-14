//
//  TaskReminder+CoreDataClass.swift
//  first_ios_app
//
//  Created by violet on 2022-01-08.
//
//

import Foundation
import CoreData

@objc(TaskReminder)
public class Task: NSManagedObject {
    //time string
    var timeString: String {
            get {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: time ?? Date())
            }
    }
    //timer that schedules notifications
    var timer: Timer = Timer()
    //reminder body
    var body: String {
        get {
            if isMedication {
                return name
            } else {
                return "Remember to take " + name
            }
        }
    }
    //helps keep track of whether the task has been updated
    var hasChanged = false
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.isMedication == rhs.isMedication && lhs.time == rhs.time
    }
}
