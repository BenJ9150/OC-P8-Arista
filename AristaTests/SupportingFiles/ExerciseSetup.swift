//
//  ExerciseSetup.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 02/08/2024.
//

import XCTest
import CoreData
@testable import Arista

class ExerciseSetup {

    // MARK: Create exercise types

    func addThreeExerciseTypes(context: NSManagedObjectContext) throws -> [ExerciseType] {
        let exerciseType1 = ExerciseType(context: context)
        exerciseType1.caloriesPerMin = 9.0
        exerciseType1.type = "Football"

        let exerciseType2 = ExerciseType(context: context)
        exerciseType2.caloriesPerMin = 9.0
        exerciseType2.type = "Running"

        let exerciseType3 = ExerciseType(context: context)
        exerciseType3.caloriesPerMin = 9.0
        exerciseType3.type = "Fitness"

        // Check creation
        if try context.fetch(ExerciseType.fetchRequest()).count != 3 {
            XCTFail("error in addThreeExerciseTypes method, count not equal to 3")
        }
        return [exerciseType1, exerciseType2, exerciseType3]
    }

    // MARK: Create user exercises

    /// Create 3 user exercises from oldest to newest, with 2 dates the same day

    func addThreeUserExercises(context: NSManagedObjectContext) throws -> (UserExerciseRepository, [ExerciseType]) {
        // Create user and 3 exercise types
        let user = try UserSetup().createUser(context: context)
        let types = try addThreeExerciseTypes(context: context)

        // Create 3 user exercises (from oldest to newest)
        let data = UserExerciseRepository(viewContext: context)
        try data.addUserExercise(
            forUser: user,
            type: types[2],
            duration: 14,
            intensity: 7,
            startDate: XCTestCase.dates[2]
        )
        try data.addUserExercise(
            forUser: user,
            type: types[1],
            duration: 12,
            intensity: 6,
            startDate: XCTestCase.dates[1]
        )
        try data.addUserExercise(
            forUser: user,
            type: types[0],
            duration: 10,
            intensity: 5,
            startDate: XCTestCase.dates[0]
        )
        return (data, types)
    }
}
