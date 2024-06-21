//
//  DefaultData.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 14/06/2024.
//

import Foundation
import CoreData

struct DefaultData {

    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }

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
        initialUser.lastName = "LEFRANCOIS"
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

        let sleep1 = Sleep(context: viewContext)
        let sleep2 = Sleep(context: viewContext)
        let sleep3 = Sleep(context: viewContext)
        let sleep4 = Sleep(context: viewContext)
        let sleep5 = Sleep(context: viewContext)
        
        let timeIntervalForADay: TimeInterval = 60 * 60 * 24
        
        sleep1.duration = (0...900).randomElement()!
        sleep1.quality = (0...10).randomElement()!
        sleep1.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*5)
        sleep1.user = user
        
        sleep2.duration = (0...900).randomElement()!
        sleep2.quality = (0...10).randomElement()!
        sleep2.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*4)
        sleep2.user = user
        
        sleep3.duration = (0...900).randomElement()!
        sleep3.quality = (0...10).randomElement()!
        sleep3.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*3)
        sleep3.user = user
        
        sleep4.duration = (0...900).randomElement()!
        sleep4.quality = (0...10).randomElement()!
        sleep4.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*2)
        sleep4.user = user
        
        sleep5.duration = (0...900).randomElement()!
        sleep5.quality = (0...10).randomElement()!
        sleep5.startDate = Date(timeIntervalSinceNow: timeIntervalForADay)
        sleep5.user = user
    }
}

// MARK: Add exercise types

private extension DefaultData {

    /// ## Attention: you need to save NSManagedObjectContext after call of this method

    func addExerciseTypes() throws {
        guard try ExerciseRepository(viewContext: viewContext).getExercise().isEmpty else {
            return
        }

        let exercise1 = Exercise(context: viewContext)
        let exercise2 = Exercise(context: viewContext)
        let exercise3 = Exercise(context: viewContext)
        let exercise4 = Exercise(context: viewContext)
        let exercise5 = Exercise(context: viewContext)
        let exercise6 = Exercise(context: viewContext)
        let exercise7 = Exercise(context: viewContext)
        let exercise8 = Exercise(context: viewContext)

        exercise1.type = "Course à pied"
        exercise1.caloriesPerMin = 9.8
        
        exercise2.type = "Cyclisme"
        exercise2.caloriesPerMin = 9.4
        
        exercise3.type = "Natation"
        exercise3.caloriesPerMin = 9.8
        
        exercise4.type = "Football"
        exercise4.caloriesPerMin = 9.0
        
        exercise5.type = "Tennis"
        exercise5.caloriesPerMin = 8.3

        exercise6.type = "Basketball"
        exercise6.caloriesPerMin = 8.1

        exercise7.type = "Marche rapide"
        exercise7.caloriesPerMin = 4.7

        exercise8.type = "Aérobic"
        exercise8.caloriesPerMin = 7.4
    }
}

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
        let exercisesToDelete = try ExerciseRepository(viewContext: viewContext).getExercise()
        if exercisesToDelete.isEmpty {
            return
        }

        for exercise in exercisesToDelete {
            viewContext.delete(exercise)
        }
        try viewContext.save()
    }
}
