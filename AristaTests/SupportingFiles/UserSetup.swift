//
//  UserSetup.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 02/08/2024.
//

import XCTest
import CoreData
@testable import Arista

class UserSetup {

    let firstName = "Ben"
    let lastName = "TEST"

    func createUser(context: NSManagedObjectContext) throws -> User {
        let user = User(context: context)
        user.firstName = firstName
        user.lastName = lastName

        // Check creation
        if try context.fetch(User.fetchRequest()).first == nil {
            XCTFail("error in createUser method, user is nil")
        }
        return user
    }
}
