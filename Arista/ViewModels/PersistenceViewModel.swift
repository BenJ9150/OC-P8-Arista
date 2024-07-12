//
//  PersistenceViewModel.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 12/07/2024.
//

import SwiftUI

class PersistenceViewModel: ObservableObject {

    // MARK: Public properties

    let persistence: PersistenceController

    @Published var loadPersistentStoresError = ""

    // MARK: Init

    init(persistence: PersistenceController = PersistenceController.init(loadStores: false)) {

        // PersistenceController is initialized without stores loaded to call loadPersistentStores
        // with completion and get any errors when loading persistent stores

        self.persistence = persistence
        loadPersistentStores()
    }
}

// MARK: Load persistent stores

extension PersistenceViewModel {

    private func loadPersistentStores() {
        persistence.loadPersistentStores { result in
            switch result {
            case .success:
                self.loadPersistentStoresError = ""
            case .failure(let error):
                self.loadPersistentStoresError = error.message
            }
        }
    }
}
