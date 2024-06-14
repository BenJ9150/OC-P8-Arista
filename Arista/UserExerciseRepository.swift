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

    func addUserExercise(type: Exercise, duration: Int, intensity: Int, startDate: Date) throws {
        let newExercise = UserExercise(context: viewContext)
        newExercise.exercise = type
        newExercise.duration = Int32(duration)
        newExercise.intensity = Int16(intensity)
        newExercise.startDate = startDate
        try viewContext.save()
    }
}
