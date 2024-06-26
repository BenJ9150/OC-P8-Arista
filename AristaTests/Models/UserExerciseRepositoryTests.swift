//
//  UserExerciseRepositoryTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
import CoreData
@testable import Arista

final class UserExerciseRepositoryTests: XCTestCase {}

// MARK: Empty entities

extension UserExerciseRepositoryTests {

    func test_EmptyEntities() {

        // Given entities are empty

        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // When getting data

        let data = UserExerciseRepository(viewContext: viewContext)
        let exercises = try? data.getUserExercise()

        // Then entities are empty

        XCTAssertNotNil(exercises)
        XCTAssert(exercises?.isEmpty == true)
    }
}

// MARK: Add and delete

extension UserExerciseRepositoryTests {

    func test_AddExercisesAndDeleteOne() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given 3 exercises have been added

            let user = createUser(context: viewContext)
            let dates = dates(context: viewContext)
            let types = createExerciseTypes(context: viewContext)

            let data = UserExerciseRepository(viewContext: viewContext)
            try data.addUserExercise(forUser: user, type: types[0], duration: 10, intensity: 5, startDate: dates[0])
            try data.addUserExercise(forUser: user, type: types[1], duration: 12, intensity: 6, startDate: dates[1])
            try data.addUserExercise(forUser: user, type: types[2], duration: 14, intensity: 7, startDate: dates[2])

            // When delete first exercise in the list (i.e. the most recent)

            try data.delete(try data.getUserExercise().first!)

            // Then there are 2 exercises, and in the right order

            let exercises = try data.getUserExercise()
            XCTAssert(exercises.count == 2)
            XCTAssert(exercises[0].category == "Running")
            XCTAssert(exercises[0].duration == 12)
            XCTAssert(exercises[0].intensity == 6)
            XCTAssert(exercises[0].startDate == dates[1])
            XCTAssert(exercises[0].date == "\(dates[1].formatted())")
            XCTAssert(exercises[0].category == types[1].type)

            XCTAssert(exercises[1].category == "Fitness")
            XCTAssert(exercises[1].duration == 14)
            XCTAssert(exercises[1].intensity == 7)
            XCTAssert(exercises[1].startDate == dates[2])
            XCTAssert(exercises[1].date == "\(dates[2].formatted())")
            XCTAssert(exercises[1].category == types[2].type)

        } catch {
            XCTFail("error in testAddExercisesAndDeleteOne of UserExerciseRepositoryTests")
        }
    }
}

// MARK: Delete rule

extension UserExerciseRepositoryTests {

    func test_DeleteRules() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given user exercise has been added (and 3 exercise types)

            let user = createUser(context: viewContext)
            let types = createExerciseTypes(context: viewContext)
            let data = UserExerciseRepository(viewContext: viewContext)
            try data.addUserExercise(forUser: user, type: types[0], duration: 10, intensity: 5, startDate: Date())

            // When deleting user

            guard let userToDelete = try viewContext.fetch(User.fetchRequest()).first else {
                XCTFail("error in test_DeleteRules of UserExerciseRepositoryTests, user to delete is nil")
                return
            }
            viewContext.delete(userToDelete)

            // Then userExercises is empty and exerciseTypes count is valid (not deleted with user)

            let userExercises = try UserExerciseRepository(viewContext: viewContext).getUserExercise()
            let exerciseTypes = try viewContext.fetch(ExerciseType.fetchRequest())
            XCTAssertEqual(userExercises.count, 0)
            XCTAssertEqual(exerciseTypes.count, 3)

        } catch {
            XCTFail("error in test_DeleteRules of UserExerciseRepositoryTests")
        }
    }
}
