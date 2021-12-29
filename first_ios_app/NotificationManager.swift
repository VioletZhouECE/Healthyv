//
//  NotificationManager.swift
//  first_ios_app
//
//  Created by violet on 2021-12-29.
//

import Foundation
import SwiftUI

//register once the task is created
func registerCalendarNotifs(){
    let content = UNMutableNotificationContent()
    content.title = "Medication Time"
    content.body = "Remember to take Vemlidy"
    content.sound = UNNotificationSound.default
    
    // Configure the recurring date.
    var dateComponents = DateComponents()
    dateComponents.calendar = Calendar.current
    dateComponents.hour = 16
    dateComponents.minute = 05
       
    // Create the trigger as a repeating event.
    let trigger = UNCalendarNotificationTrigger(
             dateMatching: dateComponents, repeats: true)
    
    // Create the request
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString,
                content: content, trigger: trigger)

    // Schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { (error) in
       if error != nil {
          // ignore the errors for now
       }
    }
}

func registerTimeIntervalNotif(){
    let content = UNMutableNotificationContent()
    content.title = "Medication Time"
    content.body = "Remember to take Vemlidy"
    content.sound = UNNotificationSound.default
    
    // Create the trigger as a repeating event.
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    
    // Create the request
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString,
                content: content, trigger: trigger)

    // Schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { (error) in
       if error != nil {
          // ignore the errors for now
       }
    }
    
    print("notification scheduled")
}

func requestAuthorization() {
  UNUserNotificationCenter.current()
    .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
      //for now, we are going to assume that user accepts
    }
}

func getPendingNotif(){
    UNUserNotificationCenter.current().getPendingNotificationRequests{
               requests in
                print(requests.count)
    }
}

func setNotifications() {
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

