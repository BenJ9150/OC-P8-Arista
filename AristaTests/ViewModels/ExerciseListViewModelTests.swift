//
//  ExerciseListViewModelTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
import CoreData
import Combine
@testable import Arista

// SwiftLint: disable all

final class ExerciseListViewModelTests: XCTestCase {

    // MARK: Private property

    private let viewContext = PersistenceController(inMemory: true).container.viewContext
    private var cancellables = Set<AnyCancellable>()

    // MARK: Setup

    override func setUp() {
        emptyEntities(context: viewContext)
    }
}

// MARK: Empty entities

extension ExerciseListViewModelTests {

    func test_EmptyEntities() {

        // Given entities are empty, when fetching data (in init of ViewModel)

        let viewModel = ExerciseListViewModel(context: viewContext)

        // Then no error message and list is empty

        let fetchErrorExpectation = XCTestExpectation(description: "fetch empty list of user exercise error")
        let emptyListExpectation = XCTestExpectation(description: "fetch empty list of user exercise")

        viewModel.$fetchError
            .sink { fetchError in
                XCTAssertEqual(fetchError, "")
                fetchErrorExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$userExercises
            .sink { userExercises in
                XCTAssertTrue(userExercises.isEmpty)
                emptyListExpectation.fulfill()
            }
            .store(in: &cancellables)

        // Expectation timeout
        wait(for: [fetchErrorExpectation, emptyListExpectation], timeout: 10)
    }
}

// MARK: Add and delete

extension ExerciseListViewModelTests {

    func test_FetchExercisesAndDeleteOne() {
        do {
            // Given 3 exercises have been added

            let user = createUser(context: viewContext)
            let dates = dates(context: viewContext)
            let types = createExerciseTypes(context: viewContext)

            let data = UserExerciseRepository(viewContext: viewContext)
            try data.addUserExercise(forUser: user, type: types[0], duration: 10, intensity: 5, startDate: dates[0])
            try data.addUserExercise(forUser: user, type: types[1], duration: 12, intensity: 6, startDate: dates[1])
            try data.addUserExercise(forUser: user, type: types[2], duration: 14, intensity: 7, startDate: dates[2])

            // When fetching user data (in init of UserDataViewModel)

            let viewModel = ExerciseListViewModel(context: viewContext)

            // And when deleting first exercise in the list (i.e. the most recent)

            viewModel.delete(viewModel.userExercises.first!)

            // Then there are 2 exercises, and no error message

            let listExpectation = XCTestExpectation(description: "fetch list of user exercise")
            let fetchErrorExpectation = XCTestExpectation(description: "fetch list of user exercise error")

            viewModel.$userExercises
                .sink { userExercises in
                    XCTAssertEqual(userExercises.count, 2)
                    listExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            viewModel.$fetchError
                .sink { fetchError in
                    XCTAssertEqual(fetchError, "")
                    fetchErrorExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            // Expectation timeout
            wait(for: [listExpectation, fetchErrorExpectation], timeout: 10)

        } catch {
            XCTFail("error in test_FetchExercisesAndDeleteOne of ExerciseListViewModelTests")
        }
    }
}
