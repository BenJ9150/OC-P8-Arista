//
//  UserRepositoryTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
@testable import Arista

final class UserRepositoryTests: XCTestCase {

    // MARK: Private properties

    private let defaultSleepSessionsCount = 12
    private let defaultExerciseTypesCount = 8
}

// MARK: Empty entities

extension UserRepositoryTests {

    func test_GivenThatEntitiesAreEmpty_WhenFetchingUser_ThenUserIsNil() {
        do {
            // Given that entities are empty

            let viewContext = PersistenceController(inMemory: true).container.viewContext
            emptyEntities(context: viewContext)

            // When fetching user

            let data = UserRepository(viewContext: viewContext)
            let user = try data.getUser()

            // Then user is nil

            XCTAssertNil(user)

        } catch {
            XCTFail("error in Empty entities of UserRepositoryTests")
        }
    }
}

// MARK: Get user

extension UserRepositoryTests {

    func test_GivenThatUserExists_WhenFetchingUser_ThenUserIsNotNil() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that user is created

            let userSetup = UserSetup()
            _ = try userSetup.createUser(context: viewContext)

            // When fetching user

            let data = UserRepository(viewContext: viewContext)
            let user = try? data.getUser()

            // Then user is not nil

            XCTAssertNotNil(user)
            XCTAssert(user?.firstName == userSetup.firstName)
            XCTAssert(user?.lastName == userSetup.lastName)

        } catch {
            XCTFail("error in Get user of UserRepositoryTests")
        }
    }
}
