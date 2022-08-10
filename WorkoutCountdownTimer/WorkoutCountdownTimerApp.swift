//
//  WorkoutCountdownTimerApp.swift
//  WorkoutCountdownTimer
//
//  Created by Oliver Kerr on 10/8/2022.
//

import SwiftUI

@main
struct WorkoutCountdownTimerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LandingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
