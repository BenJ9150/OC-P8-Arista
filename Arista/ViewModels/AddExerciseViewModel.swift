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
    @Published var startTime: String = ""
    @Published var duration: String = ""
    @Published var intensity: String = ""

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExerciseTypes()
    }
}

// MARK: Add user exercise

extension AddExerciseViewModel {

    func addUserExercise() -> Bool { // TODO: Gérer les erreurs
        guard let exerciseType = exercise,
              let durationToInt = Int32(duration), let intensityToInt = Int16(intensity) else {
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
                duration: durationToInt,
                intensity: intensityToInt,
                startDate: Date.now // TODO: Mettre vrai valeur
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
