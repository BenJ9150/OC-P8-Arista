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
    @Published var fetchError: String = ""

    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchSleepSessions()
    }
}

// MARK: Fetch sleep sessions

extension SleepHistoryViewModel {

    private func fetchSleepSessions() {
        do {
            sleepSessions = try SleepRepository(viewContext: viewContext).getSleepSessions()
            fetchError = ""

        } catch {
            fetchError = AppError.fetchSleeps.message
        }
    }
}
