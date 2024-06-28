//
//  DefaultData.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 14/06/2024.
//

import Foundation
import CoreData

struct DefaultData {

    // MARK: Public property

    let viewContext: NSManagedObjectContext

    // MARK: Init

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
}

// MARK: Public method

extension DefaultData {

    func apply() throws {
        let initialUser = addInitialUser()
        try addSleepSessions(forUser: initialUser)
        try addExerciseTypes()
        try viewContext.save()
    }
}

// MARK: Add initial user

private extension DefaultData {

    /// ## Attention: you need to save NSManagedObjectContext after call of this method

    func addInitialUser() -> User {
        if let savedUser = try? UserRepository(viewContext: viewContext).getUser() {
            return savedUser
        }
        let initialUser = User(context: viewContext)
        initialUser.firstName = "Benjamin"
        initialUser.lastName = "LEFAUX"
        return initialUser
    }
}

// MARK: Add sleep sessions

private extension DefaultData {

    /// ## Attention: you need to save NSManagedObjectContext after call of this method
    /// Delete rule: sleep sessions were deleted when associated user is deleted

    func addSleepSessions(forUser user: User) throws {
        guard try SleepRepository(viewContext: viewContext).getSleepSessions().isEmpty else {
            return
        }

        sleepBuilder(forUser: user, dateFactor: 1)
        sleepBuilder(forUser: user, dateFactor: 2)
        sleepBuilder(forUser: user, dateFactor: 3)
        sleepBuilder(forUser: user, dateFactor: 4)
        sleepBuilder(forUser: user, dateFactor: 5)
        sleepBuilder(forUser: user, dateFactor: 6)
        sleepBuilder(forUser: user, dateFactor: 7)
        sleepBuilder(forUser: user, dateFactor: 8)
        sleepBuilder(forUser: user, dateFactor: 9)
        sleepBuilder(forUser: user, dateFactor: 10)
        sleepBuilder(forUser: user, dateFactor: 11)
        sleepBuilder(forUser: user, dateFactor: 12)
    }

    func sleepBuilder(forUser user: User, dateFactor: Double) {
        let sleep = Sleep(context: viewContext)
        let timeIntervalForADay: TimeInterval = 60 * 60 * 24

        sleep.duration = (0...900).randomElement()!
        sleep.quality = (0...10).randomElement()!
        sleep.startDate = Date(timeIntervalSinceNow: timeIntervalForADay * dateFactor)
        sleep.user = user
    }
}

// MARK: Add exercise types

private extension DefaultData {

    /// ## Attention: you need to save NSManagedObjectContext after call of this method

    func addExerciseTypes() throws {
        guard try ExerciseTypeRepository(viewContext: viewContext).getExercise().isEmpty else {
            return
        }

        exerciseBuilder(type: "Course à pied", calories: 9.8)
        exerciseBuilder(type: "Cyclisme", calories: 9.4)
        exerciseBuilder(type: "Natation", calories: 9.8)
        exerciseBuilder(type: "Football", calories: 9.0)
        exerciseBuilder(type: "Tennis", calories: 8.3)
        exerciseBuilder(type: "Basketball", calories: 8.1)
        exerciseBuilder(type: "Marche rapide", calories: 4.7)
        exerciseBuilder(type: "Aérobic", calories: 7.4)
    }

    func exerciseBuilder(type: String, calories: NSDecimalNumber) {
        let exercise = ExerciseType(context: viewContext)
        exercise.type = type
        exercise.caloriesPerMin = calories
    }
}

/*
// MARK: - TEST

extension DefaultData {

    // Method just for test delete rules in CoreData

    func deleteUser() throws {
        guard let userToDelete = try UserRepository(viewContext: viewContext).getUser() else {
            return
        }
        viewContext.delete(userToDelete)
        try viewContext.save()
    }

    func deleteExerciseTypes() throws {
        let exercisesToDelete = try ExerciseTypeRepository(viewContext: viewContext).getExercise()
        if exercisesToDelete.isEmpty {
            return
        }

        for exercise in exercisesToDelete {
            viewContext.delete(exercise)
        }
        try viewContext.save()
    }
}
*/
