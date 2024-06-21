//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class SleepHistoryViewModel: ObservableObject {

    @Published var sleepSessions = [Sleep]()
    
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchSleepSessions()
    }
}

// MARK: Fetch sleep sessions

extension SleepHistoryViewModel {

    private func fetchSleepSessions() { // TODO: Gérer les erreurs
        do {
            let sleepRepository = SleepRepository(viewContext: viewContext)
            sleepSessions = try sleepRepository.getSleepSessions()

        } catch {}
    }
}
