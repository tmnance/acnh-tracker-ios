//
//  ACNH_TrackerApp.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 11/20/21.
//

import SwiftUI

@main
struct ACNH_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
