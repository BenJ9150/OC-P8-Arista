//
//  ExerciseTypeRepositoryTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
import CoreData
@testable import Arista

final class ExerciseTypeRepositoryTests: XCTestCase {

    // MARK: Private methods

    private func emptyEntities(context: NSManagedObjectContext) {
        do {
            let exerciseTypes = try context.fetch(ExerciseType.fetchRequest())
            for exerciseType in exerciseTypes {
                context.delete(exerciseType)
            }
            try context.save()

        } catch {
            XCTFail("error in emptyEntities of ExerciseTypeRepositoryTests")
        }
    }
}

// MARK: Empty entities

extension ExerciseTypeRepositoryTests {

    func test_EmptyEntities() {

        // Given entities are empty

        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // When getting data

        let data = ExerciseTypeRepository(viewContext: viewContext)
        let exercises = try? data.getExercise()

        // Then entities are empty

        XCTAssertNotNil(exercises)
        XCTAssert(exercises?.isEmpty == true)
    }
}

// MARK: Add exercise types

extension ExerciseTypeRepositoryTests {

    func test_AddExerciseTypesAndGetInAlphabeticalOrder() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given 3 exercises have been added

            let data = ExerciseTypeRepository(viewContext: viewContext)
            try data.addExercise(type: "Cyclisme", caloriesPerMin: 9.4)
            try data.addExercise(type: "Natation", caloriesPerMin: 9.8)
            try data.addExercise(type: "Football", caloriesPerMin: 9.0)

            // When get exercise types

            let exerciseTypes = try data.getExercise()

            // Then there are 3 sleep sessions, and in alphabetical order

            XCTAssert(exerciseTypes.count == 3)
            XCTAssert(exerciseTypes[0].type == "Cyclisme")
            XCTAssert(exerciseTypes[0].caloriesPerMin == 9.4)
            XCTAssert(exerciseTypes[1].type == "Football")
            XCTAssert(exerciseTypes[1].caloriesPerMin == 9.0)
            XCTAssert(exerciseTypes[2].type == "Natation")
            XCTAssert(exerciseTypes[2].caloriesPerMin == 9.8)

        } catch {
            XCTFail("error in test_AddExerciseTypesAndGetInAlphabeticalOrder of ExerciseTypeRepositoryTests")
        }
    }
}
