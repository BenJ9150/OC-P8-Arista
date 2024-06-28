//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2024.
//

import XCTest
import CoreData
import Combine
@testable import Arista

final class UserDataViewModelTests: XCTestCase {

    // MARK: Private property

    private let viewContext = PersistenceController(inMemory: true).container.viewContext
    private var cancellables = Set<AnyCancellable>()

    // MARK: Setup

    override func setUp() {
        emptyEntities(context: viewContext)
    }
}

// MARK: User is Nil

extension UserDataViewModelTests {

    func test_UserIsNil() {

        // Given no user loaded, when fetching data (in init of ViewModel)

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

    func test_UserIsValid() {

        // Given user is created

        _ = createUser(context: viewContext)

        // When fetching user data (in init of UserDataViewModel)

        let viewModel = UserDataViewModel(context: viewContext)

        // Then no error message and user is valid

        let fetchErrorExpectation = XCTestExpectation(description: "fetch user no error")
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
                XCTAssertEqual(firstName, userTestFirstName)
                firstNameExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$lastName
            .sink { lastName in
                XCTAssertEqual(lastName, userTestLastName)
                lastNameExpectation.fulfill()
            }
            .store(in: &cancellables)

        // Expectation timeout
        wait(for: [fetchErrorExpectation, firstNameExpectation, lastNameExpectation], timeout: 10)
    }
}
