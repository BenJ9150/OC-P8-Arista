//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
import Combine
@testable import Arista

final class UserDataViewModelTests: XCTestCase {

    // MARK: Private property

    private var cancellables = Set<AnyCancellable>()
}

// MARK: User is Nil

extension UserDataViewModelTests {

    func test_GivenThatNoUser_WhenFetching_ThenErrorMessageAndUserDataEmpty() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // Given that there is no user, when fetching data (in init of ViewModel)

        let viewModel = UserDataViewModel(context: viewContext)

        // Then there is a fetch error message and user data are empty

        let fetchErrorExpectation = XCTestExpectation(description: "fetch nil user error")
        let firstNameExpectation = XCTestExpectation(description: "fetch nil user first name")
        let lastNameExpectation = XCTestExpectation(description: "fetch nil user last name")

        viewModel.$fetchError
            .sink { fetchError in
                XCTAssertEqual(fetchError, AppError.userIsNil.message)
                fetchErrorExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$firstName
            .sink { firstName in
                XCTAssertEqual(firstName, "")
                firstNameExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$lastName
            .sink { lastName in
                XCTAssertEqual(lastName, "")
                lastNameExpectation.fulfill()
            }
            .store(in: &cancellables)

        // Expectation timeout
        wait(for: [fetchErrorExpectation, firstNameExpectation, lastNameExpectation], timeout: 10)
    }
}

// MARK: User is valid

extension UserDataViewModelTests {

    func test_GivenThatUserExists_WhenFetching_ThenNoErrorMessageAndUserDataExist() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that user is created

            let userSetup = UserSetup()
            _ = try userSetup.createUser(context: viewContext)

            // When fetching user data (in init of UserDataViewModel)

            let viewModel = UserDataViewModel(context: viewContext)

            // Then no error message and user is valid

            let fetchErrorExpectation = XCTestExpectation(description: "fetch user error")
            let firstNameExpectation = XCTestExpectation(description: "fetch user first name")
            let lastNameExpectation = XCTestExpectation(description: "fetch user last name")

            viewModel.$fetchError
                .sink { fetchError in
                    XCTAssertEqual(fetchError, "")
                    fetchErrorExpectation.fulfill()
                }
                .store(in: &cancellables)

            viewModel.$firstName
                .sink { firstName in
                    XCTAssertEqual(firstName, userSetup.firstName)
                    firstNameExpectation.fulfill()
                }
                .store(in: &cancellables)

            viewModel.$lastName
                .sink { lastName in
                    XCTAssertEqual(lastName, userSetup.lastName)
                    lastNameExpectation.fulfill()
                }
                .store(in: &cancellables)

            // Expectation timeout
            wait(for: [fetchErrorExpectation, firstNameExpectation, lastNameExpectation], timeout: 10)

        } catch {
            XCTFail("error in User is valid of UserDataViewModelTests")
        }
    }
}

// MARK: Get sleep summary

extension UserDataViewModelTests {

    func test_GivenThatThreeSleepSessionsIn2DaysAdded_WhenFetchingSleepSummary_ThenThreeSleepSessionsIn2DaysExist() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 sleep sessions have been added (from oldest to newest, with 2 last dates the same day)

            try SleepSetup().addThreeSleepSessions(context: viewContext)

            // When fetching sleep summary (in init of UserDataViewModel)

            let viewModel = UserDataViewModel(context: viewContext)

            // Then no error message, there are 1 sleep session the first date, and 2 sleep sessions the last date

            let fetchErrorExpectation = XCTestExpectation(description: "fetch sleep summary error")
            let summaryExpectation = XCTestExpectation(description: "fetch sleep summary")

            viewModel.$fetchSleepError
                .sink { fetchSleepError in
                    XCTAssertEqual(fetchSleepError, "")
                    fetchErrorExpectation.fulfill()
                }
                .store(in: &cancellables)

            viewModel.$sleepSummary
                .sink { sleepSummary in
                    XCTAssertEqual(sleepSummary.count, 2)
                    XCTAssertEqual(sleepSummary[XCTestCase.dates[0].withoutTime()]!.count, 1)
                    XCTAssertEqual(sleepSummary[XCTestCase.dates[2].withoutTime()]!.count, 2)
                    summaryExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            // Expectation timeout
            wait(for: [fetchErrorExpectation, summaryExpectation], timeout: 10)

        } catch {
            XCTFail("error in Get sleep summary of UserDataViewModelTests")
        }
    }
}

// MARK: Get Exercise summary

extension UserDataViewModelTests {

    func test_GivenThatThreeUserExercisesIn2DaysAdded_WhenFetchingExerciseSummary_ThenThreeUserExercisesIn3DaysExist() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 user exercises have been added (from oldest to newest, with 2 last dates the same day)

            _ = try ExerciseSetup().addThreeUserExercises(context: viewContext)

            // When fetching exercise summary (in init of UserDataViewModel)

            let viewModel = UserDataViewModel(context: viewContext)

            // Then no error, there is 1 exercise at the newest date, then 2 exercises, and then empty value

            let fetchErrorExpectation = XCTestExpectation(description: "fetch exercise summary error")
            let summaryExpectation = XCTestExpectation(description: "fetch exercise summary")

            viewModel.$fetchExercisesError
                .sink { fetchExercisesError in
                    XCTAssertEqual(fetchExercisesError, "")
                    fetchErrorExpectation.fulfill()
                }
                .store(in: &cancellables)

            viewModel.$exercisesSummary
                .sink { exercisesSummary in
                    let sortedDate = exercisesSummary.keys.sorted()

                    XCTAssertEqual(exercisesSummary.count, viewModel.exercisesSummaryColumns)
                    XCTAssertEqual(exercisesSummary[sortedDate[0]]!.count, 0)
                    XCTAssertEqual(exercisesSummary[sortedDate[1]]!.count, 2)
                    XCTAssertEqual(exercisesSummary[sortedDate[2]]!.count, 1)
                    summaryExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            // Expectation timeout
            wait(for: [fetchErrorExpectation, summaryExpectation], timeout: 10)

        } catch {
            XCTFail("error in Get Exercise summary of UserDataViewModelTests")
        }
    }
}
