//
//  ExerciseTypeRepository.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 14/06/2024.
//

import Foundation
import CoreData

struct ExerciseTypeRepository {

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
}

// MARK: Get Exercises

extension ExerciseTypeRepository {

    /// Get all exercise types from Database that can be use for UserExercise entity.
    /// Exercise types are sorted alphabetically.

    func getExercise() throws -> [ExerciseType] {
        let request = ExerciseType.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(SortDescriptor<ExerciseType>(\.type, order: .forward))
        ]
        return try viewContext.fetch(request)
    }
}

// MARK: Add Exercise

extension ExerciseTypeRepository {

    /// Save new exercise type in Database.

    func addExercise(type: String, caloriesPerMin: Decimal) throws {
        let newExercise = ExerciseType(context: viewContext)
        newExercise.type = type
        newExercise.caloriesPerMin = NSDecimalNumber(decimal: caloriesPerMin)
        try viewContext.save()
    }
}
