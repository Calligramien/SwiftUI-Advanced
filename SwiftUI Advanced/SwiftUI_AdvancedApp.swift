//
//  SwiftUI_AdvancedApp.swift
//  SwiftUI Advanced
//
//  Created by Damien Gautier on 27/03/2023.
//

import SwiftUI

@main
struct SwiftUI_AdvancedApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
