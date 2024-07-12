//
//  UserExerciseRepositoryTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
@testable import Arista

final class UserExerciseRepositoryTests: XCTestCase {

    // MARK: Empty entities

    func test_GivenThatEntitiesAreEmpty_WhenFetchingUserExercises_ThenUserExercisesIsEmpty() {

        // Given that entities are empty

        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // When fetching data

        let data = UserExerciseRepository(viewContext: viewContext)
        let exercises = try? data.getUserExercise()

        // Then data are empty

        XCTAssertNotNil(exercises)
        XCTAssert(exercises?.isEmpty == true)
    }
}

// MARK: Add user exercises

extension UserExerciseRepositoryTests {

    func test_GivenThatUserExercisesAdded_WhenFetching_ThenUserExercisesExistInTheRightOrder() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 user exercises have been added (from oldest to newest)

            let (userExerciseRepository, types) = try addThreeUserExercises(context: viewContext)

            // When fetching user exercises

            let exercises = try userExerciseRepository.getUserExercise()

            // Then there are 3 exercises, and in the right order (from newest to oldest)

            XCTAssert(exercises.count == 3)

            XCTAssert(exercises[0].duration == 10)
            XCTAssert(exercises[0].intensity == 5)
            XCTAssert(exercises[0].startDate == dates[0])
            XCTAssert(exercises[0].date == "\(dates[0].formatted())")
            XCTAssert(exercises[0].category == types[0].type)

            XCTAssert(exercises[1].duration == 12)
            XCTAssert(exercises[1].intensity == 6)
            XCTAssert(exercises[1].startDate == dates[1])
            XCTAssert(exercises[1].date == "\(dates[1].formatted())")
            XCTAssert(exercises[1].category == types[1].type)

            XCTAssert(exercises[2].duration == 14)
            XCTAssert(exercises[2].intensity == 7)
            XCTAssert(exercises[2].startDate == dates[2])
            XCTAssert(exercises[2].date == "\(dates[2].formatted())")
            XCTAssert(exercises[2].category == types[2].type)

        } catch {
            XCTFail("error in Add user exercises of UserExerciseRepositoryTests")
        }
    }
}

// MARK: Delete user exercise

extension UserExerciseRepositoryTests {

    func test_GivenThatThreeUserExercisesAdded_WhenDeleting_ThenTwoUserExercisesExistInTheRightOrder() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 user exercises have been added (from oldest to newest)

            let (userExerciseRepository, _) = try addThreeUserExercises(context: viewContext)

            // When deleting first exercise in the list (i.e. the most recent)

            try userExerciseRepository.delete(try userExerciseRepository.getUserExercise().first!)

            // Then there are 2 exercises, and in the right order (from newest to oldest)

            let exercises = try userExerciseRepository.getUserExercise()
            XCTAssert(exercises.count == 2)
            XCTAssert(exercises[0].startDate == dates[1])
            XCTAssert(exercises[1].startDate == dates[2])

        } catch {
            XCTFail("error in Delete user exercise of UserExerciseRepositoryTests")
        }
    }
}

// MARK: Delete rule

extension UserExerciseRepositoryTests {

    func test_GivenThatUserExerciseExist_WhenDeletingUser_ThenUserExercisesIsEmptyAndExerciseTypesAlreadyExist() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 exercises have been added (and 3 exercise types)

            _ = try addThreeUserExercises(context: viewContext)

            // When deleting user

            guard let userToDelete = try viewContext.fetch(User.fetchRequest()).first else {
                XCTFail("error in Delete rule of UserExerciseRepositoryTests, user to delete is nil")
                return
            }
            viewContext.delete(userToDelete)

            // Then userExercises is empty and exerciseTypes count is valid (not deleted with user)

            let userExercises = try UserExerciseRepository(viewContext: viewContext).getUserExercise()
            let exerciseTypes = try viewContext.fetch(ExerciseType.fetchRequest())
            XCTAssertEqual(userExercises.count, 0)
            XCTAssertEqual(exerciseTypes.count, 3)

        } catch {
            XCTFail("error in Delete rule of UserExerciseRepositoryTests")
        }
    }
}
