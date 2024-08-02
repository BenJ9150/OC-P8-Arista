//
//  SleepSetup.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 02/08/2024.
//

import XCTest
import CoreData
@testable import Arista

class SleepSetup {

    /// Create 3 sleep sessions from oldest to newest, with 2 last dates the same day

    func addThreeSleepSessions(context: NSManagedObjectContext) throws {
        // Create user
        let user = try UserSetup().createUser(context: context)

        // Create 3 sleep sessions (from oldest to newest)
        createSleep(context: context, duration: 1200, quality: 8, date: XCTestCase.dates[2], user: user)
        createSleep(context: context, duration: 1100, quality: 7, date: XCTestCase.dates[1], user: user)
        createSleep(context: context, duration: 1000, quality: 6, date: XCTestCase.dates[0], user: user)

        // Check creation
        if try context.fetch(Sleep.fetchRequest()).count != 3 {
            XCTFail("error in addThreeSleepSessions method, count not equal to 3")
        }
    }

    private func createSleep(context: NSManagedObjectContext, duration: Int32, quality: Int16, date: Date, user: User) {
        let sleep = Sleep(context: context)
        sleep.duration = duration
        sleep.quality = quality
        sleep.startDate = date
        sleep.user = user
    }
}
