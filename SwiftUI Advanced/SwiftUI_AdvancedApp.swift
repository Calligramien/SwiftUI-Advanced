//
//  SwiftUI_AdvancedApp.swift
//  SwiftUI Advanced
//
//  Created by Damien Gautier on 27/03/2023.
//

import SwiftUI
import Firebase

@main
struct SwiftUI_AdvancedApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
