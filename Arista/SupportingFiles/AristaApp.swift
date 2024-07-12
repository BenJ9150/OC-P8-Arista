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

    @StateObject private var viewModel = PersistenceViewModel()

    var viewContext: NSManagedObjectContext {
        return viewModel.persistence.container.viewContext
    }

    var body: some Scene {
        WindowGroup {
            if viewModel.loadPersistentStoresError.isEmpty {
                TabView {
                    UserDataView(viewModel: UserDataViewModel(context: viewContext))
                        .tabItem {
                            Label("Utilisateur", systemImage: "person")
                        }

                    ExerciseListView(viewModel: ExerciseListViewModel(context: viewContext))
                        .tabItem {
                            Label("Exercices", systemImage: "flame")
                        }

                    SleepHistoryView(viewModel: SleepHistoryViewModel(context: viewContext))
                        .tabItem {
                            Label("Sommeil", systemImage: "moon")
                        }
                }
            } else {
                // Error when loaded persistent store
                ErrorMessage(message: viewModel.loadPersistentStoresError)
            }
        }
    }
}
