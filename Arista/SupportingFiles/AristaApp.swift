//
//  AristaApp.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import CoreData

@main
struct AristaApp: App {

    let persistenceController = PersistenceController.shared

    var context: NSManagedObjectContext {
        return persistenceController.container.viewContext
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                UserDataView(viewModel: UserDataViewModel(context: context))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Utilisateur", systemImage: "person")
                    }

                ExerciseListView(viewModel: ExerciseListViewModel(context: context))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Exercices", systemImage: "flame")
                    }

                SleepHistoryView(viewModel: SleepHistoryViewModel(context: context))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Sommeil", systemImage: "moon")
                    }
            }
        }
    }
}
