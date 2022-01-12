//
//  first_ios_appApp.swift
//  first_ios_app
//
//  Created by violet on 2021-12-26.
//

import SwiftUI

@main
struct first_ios_appApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //a shared core data context used by the application (singleton)
    let persistenceController = PersistenceController.shared
    
    init(){
        NotificationManager.removeAllPendingNotification()
        NotificationManager.setNotifications()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
