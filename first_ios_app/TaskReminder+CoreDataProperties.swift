//
//  TaskReminder+CoreDataProperties.swift
//  first_ios_app
//
//  Created by violet on 2022-01-08.
//
//

import Foundation
import CoreData


extension TaskReminder {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<TaskReminder> {
        return NSFetchRequest<TaskReminder>(entityName: "TaskReminder")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var isMedication: Bool
    @NSManaged public var completed: Bool
    @NSManaged public var time: Date

}

extension TaskReminder : Identifiable {

}
