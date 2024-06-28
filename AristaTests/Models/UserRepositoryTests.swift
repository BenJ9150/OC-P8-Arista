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

    // MARK: Private methods

    private func emptyEntities(context: NSManagedObjectContext) {
        do {
            let users = try context.fetch(User.fetchRequest())
            for user in users {
                context.delete(user)
            }
            try context.save()

        } catch {
            XCTFail("error in emptyEntities of UserRepositoryTests")
        }
    }
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

        let newUser = User(context: viewContext)
        newUser.firstName = "Ben"
        newUser.lastName = "TEST"

        // When getting user

        let data = UserRepository(viewContext: viewContext)
        let user = try? data.getUser()

        // Then user Ben TEST is not nil

        XCTAssertNotNil(user)
        XCTAssert(user?.firstName == "Ben")
        XCTAssert(user?.lastName == "TEST")
    }
}
