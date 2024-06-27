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

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserExercises()
    }
}

// MARK: Public reload

extension ExerciseListViewModel {

    func reload() {
        fetchUserExercises()
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
