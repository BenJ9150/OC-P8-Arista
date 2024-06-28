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

    func test_EmptyEntities() {

        // Given entities are empty

        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // When getting data

        let data = SleepRepository(viewContext: viewContext)
        let sleepSessions = try? data.getSleepSessions()

        // Then entities are empty

        XCTAssertNotNil(sleepSessions)
        XCTAssert(sleepSessions?.isEmpty == true)
    }
}

// MARK: Get sleep sessions

extension SleepRepositoryTests {

    func test_GetSleepSessions() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given 3 sleep sessions have been added

            let user = createUser(context: viewContext)
            let dates = dates(context: viewContext)
            createSleep(context: viewContext, duration: 1000, quality: 6, date: dates[0], user: user)
            createSleep(context: viewContext, duration: 1100, quality: 7, date: dates[1], user: user)
            createSleep(context: viewContext, duration: 1200, quality: 8, date: dates[2], user: user)

            // When get sleep sessions

            let data = SleepRepository(viewContext: viewContext)
            let sleepSessions = try data.getSleepSessions()

            // Then there are 3 sleep sessions, and in the right order

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
            XCTFail("error in test_GetSleepSessions of SleepRepositoryTests")
        }
    }
}

// MARK: Delete rule

extension SleepRepositoryTests {

    func test_DeleteRule() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given sleep session has been added

            let user = createUser(context: viewContext)
            createSleep(context: viewContext, duration: 1000, quality: 6, date: Date(), user: user)

            // When deleting user

            guard let userToDelete = try viewContext.fetch(User.fetchRequest()).first else {
                XCTFail("error in test_DeleteRule of SleepRepositoryTests, user to delete is nil")
                return
            }
            viewContext.delete(userToDelete)

            // Then sleepSessions is empty

            let sleepSessions = try viewContext.fetch(Sleep.fetchRequest())
            XCTAssertEqual(sleepSessions.count, 0)

        } catch {
            XCTFail("error in test_DeleteRule of SleepRepositoryTests")
        }
    }
}
