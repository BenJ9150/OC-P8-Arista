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

    private var cancellables = Set<AnyCancellable>()
}

// MARK: Empty entities

extension ExerciseListViewModelTests {

    func test_GivenThatEntitiesAreEmpty_WhenFetching_ThenNoErrorMessageAndEmptyList() {

        // Given that entities are empty

        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // When fetching data (in init of ViewModel)

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

// MARK: Get user exercises

extension ExerciseListViewModelTests {

    func test_GivenThatUserExercisesAdded_WhenFetching_ThenNoErrorMessageAndUserExercisesExist() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 user exercises have been added (from oldest to newest)

            _ = try addThreeUserExercises(context: viewContext)

            // When fetching user exercises (in init of ExerciseListViewModel)

            let viewModel = ExerciseListViewModel(context: viewContext)

            // Then no error message and there are 3 user exercises

            let fetchErrorExpectation = XCTestExpectation(description: "fetch list of user exercise error")
            let listExpectation = XCTestExpectation(description: "fetch list of user exercise")

            viewModel.$fetchError
                .sink { fetchError in
                    XCTAssertEqual(fetchError, "")
                    fetchErrorExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            viewModel.$userExercises
                .sink { userExercises in
                    XCTAssertEqual(userExercises.count, 3)
                    listExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            // Expectation timeout
            wait(for: [listExpectation, fetchErrorExpectation], timeout: 10)

        } catch {
            XCTFail("error in Get user exercises of ExerciseListViewModelTests")
        }
    }
}

// MARK: Delete user execise

extension ExerciseListViewModelTests {

    func test_GivenThatThreeUserExercisesAdded_WhenDeleting_ThenNoErrorMessageAndTwoUserExercisesExist() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 user exercises have been added

            _ = try addThreeUserExercises(context: viewContext)

            // When deleting user exercise

            let viewModel = ExerciseListViewModel(context: viewContext)
            viewModel.delete(viewModel.userExercises.first!)

            // Then no error message and there are 2 user exercises

            let fetchErrorExpectation = XCTestExpectation(description: "fetch list of user exercise error")
            let listExpectation = XCTestExpectation(description: "fetch list of user exercise")

            viewModel.$fetchError
                .sink { fetchError in
                    XCTAssertEqual(fetchError, "")
                    fetchErrorExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            viewModel.$userExercises
                .sink { userExercises in
                    XCTAssertEqual(userExercises.count, 2)
                    listExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            // Expectation timeout
            wait(for: [listExpectation, fetchErrorExpectation], timeout: 10)

        } catch {
            XCTFail("error in Delete user execise of ExerciseListViewModelTests")
        }
    }
}
