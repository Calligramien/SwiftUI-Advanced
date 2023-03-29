//
//  SwiftUI_AdvancedApp.swift
//  SwiftUI Advanced
//
//  Created by Damien Gautier on 27/03/2023.
//

import SwiftUI
import Firebase
import RevenueCat


@main
struct SwiftUI_AdvancedApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure()
        Purchases.configure(withAPIKey: "appl_PQyGHWmbPoNstzJfEWYxhuDaEQC")
        Purchases.logLevel = .debug
    }
    
    var body: some Scene {
        WindowGroup {
            SignupView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
