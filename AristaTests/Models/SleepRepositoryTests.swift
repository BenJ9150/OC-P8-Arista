//
//  SleepRepositoryTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
import CoreData
@testable import Arista

final class SleepRepositoryTests: XCTestCase {

    // MARK: Private methods

    private func createSleep(context: NSManagedObjectContext, duration: Int32, quality: Int16, date: Date, user: User) {
        let sleep = Sleep(context: context)
        sleep.duration = duration
        sleep.quality = quality
        sleep.startDate = date
        sleep.user = user
    }
}

// MARK: Empty entities

extension SleepRepositoryTests {

    func test_GivenThatEntitiesAreEmpty_WhenFetchingSleeps_ThenSleepsIsEmpty() {

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

    func test_GivenThatSleepsExist_WhenFetchingSleeps_ThenSleepsExistInTheRightOrder() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 sleep sessions have been added (from oldest to newest)

            let user = createUser(context: viewContext)
            createSleep(context: viewContext, duration: 1200, quality: 8, date: dates[2], user: user)
            createSleep(context: viewContext, duration: 1100, quality: 7, date: dates[1], user: user)
            createSleep(context: viewContext, duration: 1000, quality: 6, date: dates[0], user: user)

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
}

// MARK: Delete rule

extension SleepRepositoryTests {

    func test_GivenThatSleepsExist_WhenDeletingUser_ThenSleepsIsEmpty() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that sleep session has been added

            let user = createUser(context: viewContext)
            createSleep(context: viewContext, duration: 1000, quality: 6, date: Date(), user: user)

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
