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
