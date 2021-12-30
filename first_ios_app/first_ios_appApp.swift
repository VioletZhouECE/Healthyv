//
//  first_ios_appApp.swift
//  first_ios_app
//
//  Created by violet on 2021-12-26.
//

import SwiftUI

@main
struct first_ios_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init(){
        setNotifications()
        registerTimeIntervalNotif()
        getPendingNotif()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
