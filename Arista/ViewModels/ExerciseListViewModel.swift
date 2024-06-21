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

// MARK: Fetch user exercise

extension ExerciseListViewModel {

//    private func fetchUserExercises() {
//        // TODO: fetch data in CoreData and replace dumb value below with appropriate information
//        exercises = [FakeExercise(), FakeExercise(), FakeExercise()]
//    }
    
    private func fetchUserExercises() { // TODO: Gérer les erreurs
        do {
            let userExerciseRepository = UserExerciseRepository(viewContext: viewContext)
            userExercises = try userExerciseRepository.getUserExercise()

        } catch {}
    }
}

struct FakeExercise: Identifiable {
    var id = UUID()
    
    var category: String = "Football"
    var duration: Int = 120
    var intensity: Int = 8
    var date: Date = Date()
}
