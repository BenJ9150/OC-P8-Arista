//
//  SleepRepositoryTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
@testable import Arista

final class SleepRepositoryTests: XCTestCase {

    // MARK: Empty entities

    func test_GivenThatEntitiesAreEmpty_WhenFetchingSleepSessions_ThenListOfSleepSessionsIsEmpty() {

        // Given that entities are empty

        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // When fetching data

        let data = SleepRepository(viewContext: viewContext)
        let sleepSessions = try? data.getSleepSessions()

        // Then data are empty

        XCTAssertNotNil(sleepSessions)
        XCTAssert(sleepSessions?.isEmpty == true)
    }
}

// MARK: Get sleep sessions

extension SleepRepositoryTests {

    func test_GivenThatSleepSessionsExist_WhenFetchingSleepSessions_ThenSleepSessionsExistInTheRightOrder() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 sleep sessions have been added (from oldest to newest)

            try addThreeSleepSessions(context: viewContext)

            // When fetching sleep sessions

            let data = SleepRepository(viewContext: viewContext)
            let sleepSessions = try data.getSleepSessions()

            // Then there are 3 sleep sessions, and in the right order (from newest to oldest)

            XCTAssert(sleepSessions.count == 3)
            XCTAssert(sleepSessions[0].duration == 1000)
            XCTAssert(sleepSessions[0].quality == 6)
            XCTAssert(sleepSessions[0].startDate == dates[0])
            XCTAssert(sleepSessions[0].date == "\(dates[0].formatted())")

            XCTAssert(sleepSessions[1].duration == 1100)
            XCTAssert(sleepSessions[1].quality == 7)
            XCTAssert(sleepSessions[1].startDate == dates[1])
            XCTAssert(sleepSessions[1].date == "\(dates[1].formatted())")

            XCTAssert(sleepSessions[2].duration == 1200)
            XCTAssert(sleepSessions[2].quality == 8)
            XCTAssert(sleepSessions[2].startDate == dates[2])
            XCTAssert(sleepSessions[2].date == "\(dates[2].formatted())")

        } catch {
            XCTFail("error in Get sleep sessions of SleepRepositoryTests")
        }
    }

    func test_GivenThatThreeSleepSessionsExist_WhenFetchingTwoSleepSessions_ThenListCountIsTwo() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 sleep sessions have been added (from oldest to newest)

            try addThreeSleepSessions(context: viewContext)

            // When fetching 2 sleep sessions

            let data = SleepRepository(viewContext: viewContext)
            let sleepSessions = try data.getSleepSessions(limit: 2)

            // Then there are 2 sleep sessions

            XCTAssert(sleepSessions.count == 2)

        } catch {
            XCTFail("error in Get sleep sessions of SleepRepositoryTests")
        }
    }
}

// MARK: Delete rule

extension SleepRepositoryTests {

    func test_GivenThatSleepSessionsExist_WhenDeletingUser_ThenListOfSleepSessionsIsEmpty() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 sleep sessions have been added

            try addThreeSleepSessions(context: viewContext)

            // When deleting user

            guard let userToDelete = try viewContext.fetch(User.fetchRequest()).first else {
                XCTFail("error in Delete rule of SleepRepositoryTests, user to delete is nil")
                return
            }
            viewContext.delete(userToDelete)

            // Then sleepSessions is empty

            let sleepSessions = try viewContext.fetch(Sleep.fetchRequest())
            XCTAssertEqual(sleepSessions.count, 0)

        } catch {
            XCTFail("error in Delete rule of SleepRepositoryTests")
        }
    }
}
