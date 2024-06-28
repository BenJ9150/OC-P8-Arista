//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {

    // MARK: Public properties

    @Published var exercises = [ExerciseType]()
    @Published var exercise: ExerciseType?
    @Published var startTime = Date()
    @Published var intensity: Double = 5
    @Published var fetchError: String = ""
    @Published var addError: String = ""
    @Published var showAlertError = false

    @Published var durationHour = 0 {
        didSet {
            startTime -= Double(durationHour) * 60 * 60
        }
    }

    @Published var durationMinute = 0 {
        didSet {
            startTime -= Double(durationMinute) * 60
        }
    }

    // MARK: Private properties

    private var viewContext: NSManagedObjectContext

    // MARK: Init

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExerciseTypes()
    }
}

// MARK: Add user exercise

extension AddExerciseViewModel {

    func addUserExercise() -> Bool {
        // Check duration
        guard durationHour + durationMinute > 0 else {
            addError = AppError.addUserExerciseCauseDuration.message
            showAlertError.toggle()
            return false
        }
        // Get exercise
        guard let exerciseType = exercise else {
            addError = AppError.addUserExerciseCauseExerciseIsNil.message
            showAlertError.toggle()
            return false
        }
        // Get user
        do {
            guard let user = try UserRepository(viewContext: viewContext).getUser() else {
                addError = AppError.userIsNil.message
                showAlertError.toggle()
                return false
            }
            // Add new user exercise
            return addUserExercise(forUser: user, exerciseType: exerciseType)

        } catch {
            addError = AppError.fetchUser.message
            showAlertError.toggle()
            return false
        }
    }

    private func addUserExercise(forUser user: User, exerciseType: ExerciseType) -> Bool {
        do {
            try UserExerciseRepository(viewContext: viewContext).addUserExercise(
                forUser: user,
                type: exerciseType,
                duration: Int32(durationMinute + durationHour * 60),
                intensity: Int16(intensity),
                startDate: startTime
            )
            return true

        } catch {
            addError = AppError.addUserExercise.message
            showAlertError.toggle()
            return false
        }
    }
}

// MARK: Fetch exercise types

extension AddExerciseViewModel {

    private func fetchExerciseTypes() {
        do {
            exercises = try ExerciseTypeRepository(viewContext: viewContext).getExercise()
            exercise = exercises.first
            fetchError = ""

        } catch {
            fetchError = AppError.fetchExerciseTypes.message
        }
    }
}
