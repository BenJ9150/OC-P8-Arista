//
//  XCTestCaseExtension.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
import CoreData
@testable import Arista

// MARK: Clean entities

extension XCTestCase {

    /// 3 sorted dates, from newest (index 0)  to oldest (with 2 last dates the same day)
    static let dates = [
        Date(),
        Date(timeIntervalSinceNow: -(60*60*24)),
        Date(timeIntervalSinceNow: -(60*60*24)-1)
    ]

    func emptyEntities(context: NSManagedObjectContext) {
        do {
            // Clean user
            let users = try context.fetch(User.fetchRequest())
            for user in users {
                context.delete(user)
            }
            // Clean sleep sessions
            let sleepSessions = try context.fetch(Sleep.fetchRequest())
            for sleep in sleepSessions {
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
}
