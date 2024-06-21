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

    func addUserExercise() -> Bool {
        // TODO: Ajouter ici la logique pour créer et sauvegarder un nouvel exercice dans CoreData
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
