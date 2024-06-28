//
//  UserExerciseRepository.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 14/06/2024.
//

import Foundation
import CoreData

struct UserExerciseRepository {

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
}

// MARK: Get User Exercises

extension UserExerciseRepository {

    /// Get all user exercises from Database sorted by date (most recent first).

    func getUserExercise() throws -> [UserExercise] {
        let request = UserExercise.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(SortDescriptor<UserExercise>(\.startDate, order: .reverse))
        ]
        return try viewContext.fetch(request)
    }
}

// MARK: Add User Exercise

extension UserExerciseRepository {

    /// Save new user exercise in Database.

    func addUserExercise(
        forUser user: User,
        type: ExerciseType,
        duration: Int32,
        intensity: Int16,
        startDate: Date
    ) throws {

        let newExercise = UserExercise(context: viewContext)
        newExercise.exerciseType = type
        newExercise.duration = Int32(duration)
        newExercise.intensity = Int16(intensity)
        newExercise.startDate = startDate
        newExercise.user = user
        try viewContext.save()
    }
}

// MARK: Delete User Exercise

extension UserExerciseRepository {

    /// Delete  new user exercise from Database.

    func delete(_ userExercice: UserExercise) throws {
        viewContext.delete(userExercice)
        try viewContext.save()
    }
}
