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

    // MARK: Sleep summary properties

    @Published var sleepSummary: [Date: [Sleep]] = [:]
    @Published var fetchSleepError: String = ""
    private let sleepSummaryCount = 12
    let sleepSummaryColumns = 6

    // MARK: Exercise summary properties

    @Published var exercisesSummary: [Date: [UserExercise]] = [:]
    @Published var caloriesPerDay: [Date: [Calories]] = [:]
    @Published var fetchExercisesError: String = ""
    private let exercisesSummaryCount = 9
    let exercisesSummaryColumns = 3

    // MARK: Private properties

    private let viewContext: NSManagedObjectContext

    // MARK: Init

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
        fetchSummaries()
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

// MARK: Summaries

extension UserDataViewModel {

    func fetchSummaries() {
        fetchSleepSummary()
        fetchExercisesSummary()
    }
}

// MARK: Sleep summary

extension UserDataViewModel {

    private func fetchSleepSummary() {
        do {
            // Fetch last sleep sessions
            let sleepRepo = SleepRepository(viewContext: viewContext)
            let sleepSessions = try sleepRepo.getSleepSessions(limit: sleepSummaryCount)
            fetchSleepError = ""
            sleepSummary.removeAll()

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

// MARK: Exercises summary

extension UserDataViewModel {

    private func fetchExercisesSummary() {
        do {
            // Fetch last user exercises
            let userExerciseRepo = UserExerciseRepository(viewContext: viewContext)
            let userExercises = try userExerciseRepo.getUserExercise(limit: exercisesSummaryCount)
            fetchExercisesError = ""
            exercisesSummary.removeAll()

            for userExercise in userExercises {
                if exercisesSummary.keys.contains(userExercise.dateWithoutTime) {
                    exercisesSummary[userExercise.dateWithoutTime]?.append(userExercise)
                } else {
                    exercisesSummary[userExercise.dateWithoutTime] = [userExercise]
                }
            }
            // Complete with empty value to have exact columns count
            completExercisesToExactColumnsCount()
            // Group calories
            groupCaloriesPerDay()

        } catch {
            fetchExercisesError = AppError.fetchUserExercises.message
        }
    }

    private func completExercisesToExactColumnsCount() {
        if let oldestDay = exercisesSummary.keys.sorted().first {
            var dateIndex = 1.0
            while exercisesSummary.keys.count < exercisesSummaryColumns {
                exercisesSummary[oldestDay - 60 * 60 * 24 * dateIndex] = []
                dateIndex += 1.0
            }
        }
    }

    private func groupCaloriesPerDay() {
        caloriesPerDay.removeAll()
        for (date, exercises) in exercisesSummary {
            let calories = Calories(duration: 0)
            for exercise in exercises {
                if let caloriesPerMin = exercise.exerciseType?.caloriesPerMin {
                    calories.duration += Int32(caloriesPerMin * Float(exercise.duration))
                }
            }
            caloriesPerDay[date] = [calories]
        }
    }
}
