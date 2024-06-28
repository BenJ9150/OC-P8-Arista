//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class SleepHistoryViewModel: ObservableObject {

    // MARK: Public properties

    @Published var sleepSessions = [Sleep]()
    @Published var fetchError: String = ""

    // MARK: Private properties

    private let viewContext: NSManagedObjectContext

    // MARK: Init

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
