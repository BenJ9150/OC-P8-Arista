//
//  UserRepositoryTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
import CoreData
@testable import Arista

final class UserRepositoryTests: XCTestCase {

    // MARK: Private properties

    private let defaultSleepSessionsCount = 12
    private let defaultExerciseTypesCount = 8
}

// MARK: Empty entities

extension UserRepositoryTests {

    func test_EmptyEntities() {
        do {
            // Given entities are empty

            let viewContext = PersistenceController(inMemory: true).container.viewContext
            emptyEntities(context: viewContext)

            // When getting user

            let data = UserRepository(viewContext: viewContext)
            let user = try data.getUser()

            // Then user is nil

            XCTAssertNil(user)

        } catch {
            XCTFail("error in test_EmptyEntities of UserRepositoryTests")
        }
    }
}

// MARK: Get user

extension UserRepositoryTests {

    func test_GetUser() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // Given user is created

        _ = createUser(context: viewContext)

        // When getting user

        let data = UserRepository(viewContext: viewContext)
        let user = try? data.getUser()

        // Then user Ben TEST is not nil

        XCTAssertNotNil(user)
        XCTAssert(user?.firstName == userTestFirstName)
        XCTAssert(user?.lastName == userTestLastName)
    }
}
