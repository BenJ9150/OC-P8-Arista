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

    } catch {
        XCTFail("error in emptyEntities of DefaultDataTests")
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

func dates(context: NSManagedObjectContext) -> [Date] {
    return [
        Date(),
        Date(timeIntervalSinceNow: -(60*60*24)),
        Date(timeIntervalSinceNow: -(60*60*24*2))
    ]
}
