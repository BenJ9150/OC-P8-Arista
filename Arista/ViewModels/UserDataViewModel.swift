//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var fetchError: String = ""

    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
    }
}

// MARK: Fetch user data

extension UserDataViewModel {

    private func fetchUserData() {
        do {
            guard let user = try UserRepository().getUser() else {
                fetchError = AppError.userIsNil.message
                return
            }
            // update properties
            firstName = user.firstName ?? ""
            lastName = user.lastName ?? ""
            fetchError = ""

        } catch {
            fetchError = AppError.fetchUser.message
        }
    }
}
