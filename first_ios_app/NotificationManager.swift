//
//  NotificationManager.swift
//  first_ios_app
//
//  Created by violet on 2021-12-29.
//

import Foundation
import SwiftUI

class NotificationManager {
    
    static func rescheduleNotification(task: Task, firesToday: Bool){
        print("reschedule notification for " + task.id.uuidString)
        unregisterNotification(task: task)
        registerNotification(task: task, firesToday: firesToday)
    }

    //if firesToday == true, firesAt : today, otherwise firesAt : tomorrow
    static func registerNotification(task: Task, firesToday: Bool){
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        dateComponents.hour = Calendar.current.component(.hour, from: task.time)
        dateComponents.minute = Calendar.current.component(.minute, from: task.time)
        var firesAtdate = Calendar(identifier: .gregorian).date(from: dateComponents)!
        if firesToday == false || task.time < Date(){
            var oneDay = DateComponents()
            oneDay.day = 1
            firesAtdate = Calendar.current.date(byAdding: oneDay, to: firesAtdate)!
        }
        let timer = Timer(fireAt: firesAtdate, interval: 60*60*24, target: self, selector: #selector(runNotificationScheduler), userInfo: task, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        task.timer = timer
    }
    
    static func unregisterNotification(task: Task){
        task.timer.invalidate()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
    
    @objc static private func runNotificationScheduler(timer: Timer){
        print("run notification scheduler")
        //if the task is not completed, schedule notifications
        let task = timer.userInfo as! Task
        if task.completed == false {
            sendNotificationImmediately(title: task.name, body: task.body, identifier: task.id.uuidString)
            registerTimeIntervalNotification(title: task.name, body: task.body, timeInterval: 60, identifier: task.id.uuidString)
        }
    }
    
    static private func sendNotificationImmediately(title: String, body: String, identifier: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Create the request
        let request = UNNotificationRequest(identifier: identifier,
                    content: content, trigger: nil)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // ignore the errors for now
           }
        }
    }

    static private func registerTimeIntervalNotification(title: String, body: String, timeInterval: Double, identifier: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Create the trigger as a repeating event.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        
        // Create the request
        let request = UNNotificationRequest(identifier: identifier,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // ignore the errors for now
           }
        }
    }

    static func requestAuthorization() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
          //for now, we are going to assume that user accepts
        }
    }

    static func getPendingNotifications(){
        UNUserNotificationCenter.current().getPendingNotificationRequests{
                   requests in
                    print(requests.count)
        }
    }
    
    static func removeAllPendingNotification(){
        print("remove all pending notifications")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    static func setNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings{
                    settings in
                    switch settings.authorizationStatus {
                        case .notDetermined:
                            requestAuthorization()
                    case .denied:
                        print("denied access")
                    case .authorized:
                        print("authorized")
                    case .provisional:
                        print("provisional")
                    case .ephemeral:
                        print("ephemeral")
                    @unknown default:
                        fatalError("unknown cases")
                    }
        }
    }
}

