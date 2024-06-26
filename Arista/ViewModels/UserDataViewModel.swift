//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {

    // MARK: Public properties

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var fetchError: String = ""

    // MARK: Private properties

    private let viewContext: NSManagedObjectContext

    // MARK: Init

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
    }
}

// MARK: Fetch user data

extension UserDataViewModel {

    private func fetchUserData() {
        do {
            guard let user = try UserRepository(viewContext: viewContext).getUser(),
                  let userFirstName = user.firstName,
                  let userLastName = user.lastName else {
                fetchError = AppError.userIsNil.message
                return
            }
            // update properties
            firstName = userFirstName
            lastName = userLastName
            fetchError = ""

        } catch {
            fetchError = AppError.fetchUser.message
        }
    }
}
