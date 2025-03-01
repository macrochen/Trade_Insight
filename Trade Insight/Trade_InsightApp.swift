//
//  Trade_InsightApp.swift
//  Trade Insight
//
//  Created by jolin on 2025/3/1.
//

import SwiftUI

@main
struct Trade_InsightApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
