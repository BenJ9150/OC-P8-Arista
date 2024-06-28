//
//  DefaultDataTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
import CoreData
@testable import Arista

final class DefaultDataTests: XCTestCase {

    // MARK: Private properties

    private let defaultSleepSessionsCount = 12
    private let defaultExerciseTypesCount = 8

    // MARK: Private methods

    private func emptyEntities(context: NSManagedObjectContext) {
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
}

// MARK: Load default data

extension DefaultDataTests {

    func test_LoadDefaultData() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given default data are loaded

            try DefaultData(viewContext: viewContext).apply()

            // When get all data

            let user = try viewContext.fetch(User.fetchRequest()).first
            let sleepSessions = try viewContext.fetch(Sleep.fetchRequest())
            let exerciseTypes = try viewContext.fetch(ExerciseType.fetchRequest())

            // Then user is not nil, sleepSessions count and exerciseTypes count are valid

            XCTAssertNotNil(user)
            XCTAssertEqual(sleepSessions.count, defaultSleepSessionsCount)
            XCTAssertEqual(exerciseTypes.count, defaultExerciseTypesCount)

        } catch {
            XCTFail("error in test_LoadDefaultData of DefaultDataTests")
        }
    }
}

// MARK: Reload default data

extension DefaultDataTests {

    func test_ReloadDefaultData() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given default data are loaded

            try DefaultData(viewContext: viewContext).apply()

            // When loading a second time

            try DefaultData(viewContext: viewContext).apply()
            

            // Then sleepSessions count and exerciseTypes count are valid, and not duplicate

            let sleepSessions = try viewContext.fetch(Sleep.fetchRequest())
            let exerciseTypes = try viewContext.fetch(ExerciseType.fetchRequest())
            XCTAssertEqual(sleepSessions.count, defaultSleepSessionsCount)
            XCTAssertEqual(exerciseTypes.count, defaultExerciseTypesCount)

        } catch {
            XCTFail("error in test_LoadDefaultData of DefaultDataTests")
        }
    }
}
