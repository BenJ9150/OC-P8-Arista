//
//  ExerciseRepository.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 14/06/2024.
//

import Foundation
import CoreData

struct ExerciseRepository {

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
}

// MARK: Get Exercises

extension ExerciseRepository {

    /// Get all exercise types from Database that can be use for UserExercise entity.
    /// Exercise types are sorted alphabetically.

    func getExercise() throws -> [Exercise] {
        let request = Exercise.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(SortDescriptor<Exercise>(\.type, order: .forward))
        ]
        return try viewContext.fetch(request)
    }
}

// MARK: Add Exercise

extension ExerciseRepository {

    /// Save new exercise type in Database.

    func addExercise(type: String, caloriesPerMin: Decimal) throws {
        let newExercise = Exercise(context: viewContext)
        newExercise.type = type
        newExercise.caloriesPerMin = NSDecimalNumber(decimal: caloriesPerMin)
        try viewContext.save()
    }
}
