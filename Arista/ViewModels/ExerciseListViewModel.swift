//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

import CoreData

class ExerciseListViewModel: ObservableObject {

    @Published var userExercises = [UserExercise]()

    var viewContext: NSManagedObjectContext
    var selection = Set<String>()

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserExercises()
    }
}

// MARK: Public method

extension ExerciseListViewModel {

    func reload() {
        fetchUserExercises()
    }

    func delete(_ userExercise: UserExercise) { // TODO: Gérer les erreurs
        do {
            let userExerciseRepository = UserExerciseRepository(viewContext: viewContext)
            try userExerciseRepository.delete(userExercise)

        } catch {}
    }
}

// MARK: Fetch user exercise

extension ExerciseListViewModel {

    private func fetchUserExercises() { // TODO: Gérer les erreurs
        do {
            let userExerciseRepository = UserExerciseRepository(viewContext: viewContext)
            userExercises = try userExerciseRepository.getUserExercise()

        } catch {}
    }
}
