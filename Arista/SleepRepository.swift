//
//  SleepRepository.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 14/06/2024.
//

import Foundation
import CoreData

struct SleepRepository {

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
}

// MARK: Get sleep sessions

extension SleepRepository {

    /// Get all sleep sessions from Database sorted by date (most recent first).

    func getSleepSessions() throws -> [Sleep] {
        let request = Sleep.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(SortDescriptor<Sleep>(\.startDate, order: .reverse))
        ]
        return try viewContext.fetch(request)
    }
}
