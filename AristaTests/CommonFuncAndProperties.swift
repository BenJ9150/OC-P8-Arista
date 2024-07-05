//
//  CommonFuncAndProperties.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
import CoreData
@testable import Arista

// MARK: Clean entities

func emptyEntities(context: NSManagedObjectContext) {
    do {
        // Clean user
        let users = try context.fetch(User.fetchRequest())
        for user in users {
            context.delete(user)
        }
        // Clean sleeps
        let sleeps = try context.fetch(Sleep.fetchRequest())
        for sleep in sleeps {
            context.delete(sleep)
        }
        // Clean exercise types
        let exerciseTypes = try context.fetch(ExerciseType.fetchRequest())
        for exerciseType in exerciseTypes {
            context.delete(exerciseType)
        }
        // Clean user exercises
        let userExercises = try context.fetch(UserExercise.fetchRequest())
        for userExercise in userExercises {
            context.delete(userExercise)
        }
        try context.save()

    } catch let error {
        XCTFail("error in emptyEntities method, error: \(error.localizedDescription)")
    }
}

// MARK: Create user

let userTestFirstName = "Ben"
let userTestLastName = "TEST"

func createUser(context: NSManagedObjectContext) -> User {
    let user = User(context: context)
    user.firstName = userTestFirstName
    user.lastName = userTestLastName
    return user
}

// MARK: Get dates

/// 3 sorted dates, from newest (index 0)  to oldest
let dates = [
    Date(),
    Date(timeIntervalSinceNow: -(60*60*24)),
    Date(timeIntervalSinceNow: -(60*60*24*2))
]

// MARK: Create exercise types

private func addThreeExerciseTypes(context: NSManagedObjectContext) -> [ExerciseType] {
    let exerciseType1 = ExerciseType(context: context)
    exerciseType1.caloriesPerMin = 9.0
    exerciseType1.type = "Football"

    let exerciseType2 = ExerciseType(context: context)
    exerciseType2.caloriesPerMin = 9.0
    exerciseType2.type = "Running"

    let exerciseType3 = ExerciseType(context: context)
    exerciseType3.caloriesPerMin = 9.0
    exerciseType3.type = "Fitness"

    return [exerciseType1, exerciseType2, exerciseType3]
}

// MARK: Create user exercises

func addThreeUserExercises(context: NSManagedObjectContext) throws -> (UserExerciseRepository, [ExerciseType]) {

    // Create user and 3 exercise types
    let user = createUser(context: context)
    let types = addThreeExerciseTypes(context: context)

    // Create 3 user exercises (from oldest to newest)
    let data = UserExerciseRepository(viewContext: context)
    try data.addUserExercise(forUser: user, type: types[2], duration: 14, intensity: 7, startDate: dates[2])
    try data.addUserExercise(forUser: user, type: types[1], duration: 12, intensity: 6, startDate: dates[1])
    try data.addUserExercise(forUser: user, type: types[0], duration: 10, intensity: 5, startDate: dates[0])

    return (data, types)
}
