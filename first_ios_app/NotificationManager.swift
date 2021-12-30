//
//  NotificationManager.swift
//  first_ios_app
//
//  Created by violet on 2021-12-29.
//

import Foundation
import SwiftUI

class NotificationManager {

    static func registerCalendarNotif(title: String, body: String, dateComponents: DateComponents, identifier: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)
        
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


    static func registerTimeIntervalNotif(title: String, body: String, timeInterval: Double, identifier: String){
        
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

    static func getPendingNotif(){
        UNUserNotificationCenter.current().getPendingNotificationRequests{
                   requests in
                    print(requests.count)
        }
    }

    static func removeNotif(){
        //cancel the unsent calendar notification for that day
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["violet-vemlidy-calendar"])
        //schedule for tomorrow
        let midnight = Calendar.current.startOfDay(for: Date())
        let fromDate = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDate)
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 17
        dateComponents.minute = 45
        registerCalendarNotif(title:"Medication Time", body:"Remember to take Vemlidy", dateComponents:dateComponents, identifier: "violet-vemlidy-calendar")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["violet-vemlidy-interval"])
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

