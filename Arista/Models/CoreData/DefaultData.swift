//
//  DefaultData.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 14/06/2024.
//

import Foundation
import CoreData

struct DefaultData {

    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }

    func apply() throws {
        if (try? UserRepository(viewContext: viewContext).getUser()) == nil {
            let initialUser = try addInitialUser()
            try addSleepSessions(forUser: initialUser)
            try? viewContext.save()
        }
    }
}

private extension DefaultData {

    // MARK: Add initial user

    /// ## Attention: you need to save NSManagedObjectContext after call of this method

    func addInitialUser() throws -> User {
        let initialUser = User(context: viewContext)
        initialUser.firstName = "Benjamin"
        initialUser.lastName = "LEFRANCOIS"
        return initialUser
    }

    // MARK: Add sleep sessions

    /// ## Attention: you need to save NSManagedObjectContext after call of this method

    func addSleepSessions(forUser user: User) throws {
        let sleepRepository = SleepRepository(viewContext: viewContext)
        guard try sleepRepository.getSleepSessions().isEmpty else {
            return
        }

        let sleep1 = Sleep(context: viewContext)
        let sleep2 = Sleep(context: viewContext)
        let sleep3 = Sleep(context: viewContext)
        let sleep4 = Sleep(context: viewContext)
        let sleep5 = Sleep(context: viewContext)
        
        let timeIntervalForADay: TimeInterval = 60 * 60 * 24
        
        sleep1.duration = (0...900).randomElement()!
        sleep1.quality = (0...10).randomElement()!
        sleep1.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*5)
        sleep1.user = user
        
        sleep2.duration = (0...900).randomElement()!
        sleep2.quality = (0...10).randomElement()!
        sleep2.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*4)
        sleep2.user = user
        
        sleep3.duration = (0...900).randomElement()!
        sleep3.quality = (0...10).randomElement()!
        sleep3.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*3)
        sleep3.user = user
        
        sleep4.duration = (0...900).randomElement()!
        sleep4.quality = (0...10).randomElement()!
        sleep4.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*2)
        sleep4.user = user
        
        sleep5.duration = (0...900).randomElement()!
        sleep5.quality = (0...10).randomElement()!
        sleep5.startDate = Date(timeIntervalSinceNow: timeIntervalForADay)
        sleep5.user = user
    }
}
