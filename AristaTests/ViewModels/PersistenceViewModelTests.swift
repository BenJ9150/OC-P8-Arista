//
//  PersistenceViewModelTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 12/07/2024.
//

import XCTest
import Combine
@testable import Arista

final class PersistenceViewModelTests: XCTestCase {

    // MARK: Private property

    private var cancellables = Set<AnyCancellable>()
}

// MARK: Load persistence stores

extension PersistenceViewModelTests {

    func test_GivenThatPersistenceAreInit_WhenLoadingPersistentStores_ThenThereIsNoErrorMessage() {

        // Given PersistenceController is initialized without stores loaded

        let persistence = PersistenceController(inMemory: true, loadStores: false)

        // When loading persistent stores (in init of PersistenceViewModel)

        let viewModel = PersistenceViewModel(persistence: persistence)

        // Then there is no error message after store loaded

        let loadErrorExpectation = XCTestExpectation(description: "load persistent stores error")

        viewModel.$loadPersistentStoresError
            .sink { loadPersistentStoresError in
                XCTAssertEqual(loadPersistentStoresError, "")
                loadErrorExpectation.fulfill()
            }
            .store(in: &cancellables)

        // Expectation timeout
        wait(for: [loadErrorExpectation], timeout: 10)
    }
}
