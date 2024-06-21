//
//  UserRepository.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 14/06/2024.
//

import Foundation
import CoreData

struct UserRepository {

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
}

// MARK: Get user

extension UserRepository {

    /// Get current user from Database.
    /// MVP: Only one user is possible, so fetch limit of request set to one.

    func getUser() throws -> User? {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        return try viewContext.fetch(request).first
    }
}
