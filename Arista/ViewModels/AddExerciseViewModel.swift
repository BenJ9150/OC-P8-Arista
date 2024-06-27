//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {

    @Published var exercises = [Exercise]()
    @Published var exercise: Exercise?
    @Published var startTime = Date()
    @Published var durationHour = 0
    @Published var durationMinute = 1
    @Published var intensity: Double = 5

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExerciseTypes()
    }
}

// MARK: Add user exercise

extension AddExerciseViewModel {

    func addUserExercise() -> Bool { // TODO: Gérer les erreurs
        guard let exerciseType = exercise else {
            return false
        }
        do {
            // Get user
            guard let user = try UserRepository(viewContext: viewContext).getUser() else {
                return false
            }
            // Add new user exercise
            let userExerciseRepository = UserExerciseRepository(viewContext: viewContext)
            try userExerciseRepository.addUserExercise(
                forUser: user,
                type: exerciseType,
                duration: Int32(durationMinute + durationHour * 60),
                intensity: Int16(intensity),
                startDate: startTime
            )

        } catch {}
        return true
    }
}

// MARK: Fetch exercise types

extension AddExerciseViewModel {

    private func fetchExerciseTypes() { // TODO: Gérer les erreurs
        do {
            let exerciseRepository = ExerciseRepository(viewContext: viewContext)
            exercises = try exerciseRepository.getExercise()
            exercise = exercises.first

        } catch {}
    }
}
