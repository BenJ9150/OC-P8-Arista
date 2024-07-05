//
//  AddExerciseViewModelTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 05/07/2024.
//

import XCTest
import CoreData
import Combine
@testable import Arista

final class AddExerciseViewModelTests: XCTestCase {

    // MARK: Private property

    private var cancellables = Set<AnyCancellable>()

    // MARK: Private method

    private func checkAddErrorAndAlertToggle(_ viewModel: AddExerciseViewModel, expectedError: String) {
        // Expectation
        let fetchErrorExpectation = XCTestExpectation(description: "add user exercise error")
        let fetchAlertExpectation = XCTestExpectation(description: "add user exercise alert")

        // Add Error
        viewModel.$addError
            .sink { addError in
                XCTAssertEqual(addError, expectedError)
                fetchErrorExpectation.fulfill()
            }
            .store(in: &self.cancellables)

        // Alert toggle
        viewModel.$showAlertError
            .sink { showAlertError in
                XCTAssertTrue(showAlertError)
                fetchAlertExpectation.fulfill()
            }
            .store(in: &self.cancellables)

        // Expectation timeout
        wait(for: [fetchErrorExpectation, fetchAlertExpectation], timeout: 10)
    }
}

// MARK: Get exercise types

extension AddExerciseViewModelTests {

    func test_GivenThatExerciseTypesExist_WhenInitViewModel_ThenExerciseTypesAreFetched() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // Given that exercise types are added

        do {
            // Given that 3 exercise types are added

            _ = try addThreeExerciseTypes(context: viewContext)

            // When fetching exercise types (in init of AddExerciseViewModel)

            let viewModel = AddExerciseViewModel(context: viewContext)

            // Then no error message and there are 3 exercise types

            let fetchErrorExpectation = XCTestExpectation(description: "fetch list of exercise types error")
            let listExpectation = XCTestExpectation(description: "fetch list of exercise types")
            let exerciseExpectation = XCTestExpectation(description: "fetch first exercise of types list")

            viewModel.$fetchError
                .sink { fetchError in
                    XCTAssertEqual(fetchError, "")
                    fetchErrorExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            viewModel.$exercises
                .sink { exerciseTypes in
                    XCTAssertEqual(exerciseTypes.count, 3)
                    listExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            viewModel.$exercise
                .sink { firstExerciseType in
                    XCTAssertNotNil(firstExerciseType)
                    exerciseExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            // Expectation timeout
            wait(for: [listExpectation, fetchErrorExpectation, exerciseExpectation], timeout: 10)

        } catch {
            XCTFail("error in Get exercise types of AddExerciseViewModelTests")
        }
    }
}

// MARK: Add error (cause duration)

extension AddExerciseViewModelTests {

    func test_GivenThatDurationIsNotSet_WhenAddingUserExercise_ThenThereIsAnError() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // Given that duration is not set

        let viewModel = AddExerciseViewModel(context: viewContext)

        // When adding user exercise

        let result = viewModel.addUserExercise()

        // Then result is false, there is an add error message and alert is showed

        XCTAssertFalse(result)
        checkAddErrorAndAlertToggle(viewModel, expectedError: AppError.addUserExerciseCauseDuration.message)
    }
}

// MARK: Add error (cause exercise type nil)

extension AddExerciseViewModelTests {

    func test_GivenThatExerciseTypeIsNotSet_WhenAddingUserExercise_ThenThereIsAnError() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        // Given that exercise type is not set

        let viewModel = AddExerciseViewModel(context: viewContext)
        viewModel.durationHour = 1

        // When adding user exercise

        let result = viewModel.addUserExercise()

        // Then result is false, there is an add error message and alert is showed

        XCTAssertFalse(result)
        checkAddErrorAndAlertToggle(viewModel, expectedError: AppError.addUserExerciseCauseExerciseIsNil.message)
    }
}

// MARK: Add error (cause user is nil)

extension AddExerciseViewModelTests {

    func test_GivenThatDurationAndExerciseTypeAreSetButUserIsNil_WhenAddingUserExercise_ThenThereIsAnError() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that duration and exercise type are set but user is nil

            _ = try addThreeExerciseTypes(context: viewContext)
            let viewModel = AddExerciseViewModel(context: viewContext)
            viewModel.durationHour = 1

            let listExpectation = XCTestExpectation(description: "fetch list of exercise types")
            viewModel.$exercise
                .sink { _ in

                    // When adding user exercise

                    let result = viewModel.addUserExercise()

                    // Then result is false, there is an add error message and alert is showed

                    XCTAssertFalse(result)
                    self.checkAddErrorAndAlertToggle(viewModel, expectedError: AppError.userIsNil.message)

                    listExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            // Expectation timeout
            wait(for: [listExpectation], timeout: 10)

        } catch {
            XCTFail("error in Add error (cause user is nil) of AddExerciseViewModelTests")
        }
    }
}

// MARK: Add user exercise with success

extension AddExerciseViewModelTests {

    func test_GivenThatUserExistAndAllExerciseIsSet_WhenAddingUserExercise_ThenExerciseIsAdded() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that user exist and all exercise is set

            _ = try createUser(context: viewContext)
            _ = try addThreeExerciseTypes(context: viewContext)
            let viewModel = AddExerciseViewModel(context: viewContext)

            // Set date and duration
            let date = Date()
            viewModel.startTime = date
            viewModel.durationHour = 1
            viewModel.durationMinute = 30

            let listExpectation = XCTestExpectation(description: "fetch list of exercise types")
            viewModel.$exercise
                .sink { _ in

                    // When adding user exercise

                    let result = viewModel.addUserExercise()

                    // Then result is true and user exercise is added

                    XCTAssertTrue(result)
                    let userExercises = try? viewContext.fetch(UserExercise.fetchRequest())
                    XCTAssertEqual(userExercises?.count, 1)
                    XCTAssertEqual(userExercises?.first?.duration, 90)
                    XCTAssertEqual(userExercises?.first?.startDate, date - 90 * 60)

                    listExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            // Expectation timeout
            wait(for: [listExpectation], timeout: 10)

        } catch {
            XCTFail("error in Add user exercise with success of AddExerciseViewModelTests")
        }
    }
}
