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

    @Published var fetchError: String = ""
    @Published var deleteError: String = ""
    @Published var showAlertError = false

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

    func delete(_ userExercise: UserExercise) {
        do {
            try UserExerciseRepository(viewContext: viewContext).delete(userExercise)
            deleteError = ""
            reload()

        } catch {
            deleteError = AppError.deleteUserExercise.message
            showAlertError.toggle()
        }
    }
}

// MARK: Fetch user exercise

extension ExerciseListViewModel {

    private func fetchUserExercises() {
        do {
            userExercises = try UserExerciseRepository(viewContext: viewContext).getUserExercise()
            fetchError = ""

        } catch {
            fetchError = AppError.fetchUserExercises.message
        }
    }
}
