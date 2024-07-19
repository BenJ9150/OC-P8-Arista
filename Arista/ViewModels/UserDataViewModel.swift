//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {

    // MARK: Public user properties

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var fetchError: String = ""

    // MARK: Summary properties

    @Published var sleepSummary: [Date: [Sleep]] = [:]
    private let sleepSummaryCount = 5
    @Published var fetchSleepError: String = ""

    // MARK: Private properties

    private let viewContext: NSManagedObjectContext

    // MARK: Init

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
        fetchSleepSummary()
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

// MARK: Sleep summary

extension UserDataViewModel {

    private func fetchSleepSummary() {
        do {
            // Fetch last sleep sessions
            let sleepSessions = try SleepRepository(viewContext: viewContext).getSleepSessions(limit: sleepSummaryCount)
            fetchSleepError = ""

            for sleep in sleepSessions {
                if sleepSummary.keys.contains(sleep.dateWithoutTime) {
                    sleepSummary[sleep.dateWithoutTime]?.append(sleep)
                } else {
                    sleepSummary[sleep.dateWithoutTime] = [sleep]
                }
            }
        } catch {
            fetchSleepError = AppError.fetchSleepSessions.message
        }
    }
}
