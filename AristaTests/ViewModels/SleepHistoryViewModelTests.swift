//
//  SleepHistoryViewModelTests.swift
//  AristaTests
//
//  Created by Benjamin LEFRANCOIS on 05/07/2024.
//

import XCTest
import Combine
@testable import Arista

final class SleepHistoryViewModelTests: XCTestCase {

    // MARK: Private property

    private var cancellables = Set<AnyCancellable>()
}

// MARK: Get sleep history

extension SleepHistoryViewModelTests {

    func test_GivenThatSleepHistoryAdded_WhenFetching_ThenNoErrorMessageAndSleepHistoryExist() {
        // Clean manually all data
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        emptyEntities(context: viewContext)

        do {
            // Given that 3 sleep sessions have been added (from oldest to newest)

            try SleepSetup().addThreeSleepSessions(context: viewContext)

            // When fetching sleep sessions (in init of SleepHistoryViewModel)

            let viewModel = SleepHistoryViewModel(context: viewContext)

            // Then no error message and there are 3 sleep sessions

            let fetchErrorExpectation = XCTestExpectation(description: "fetch list of sleep sessions error")
            let listExpectation = XCTestExpectation(description: "fetch list of sleep sessions")

            viewModel.$fetchError
                .sink { fetchError in
                    XCTAssertEqual(fetchError, "")
                    fetchErrorExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            viewModel.$sleepSessions
                .sink { sleepSessions in
                    XCTAssertEqual(sleepSessions.count, 3)
                    listExpectation.fulfill()
                }
                .store(in: &self.cancellables)

            // Expectation timeout
            wait(for: [listExpectation, fetchErrorExpectation], timeout: 10)

        } catch {
            XCTFail("error in Get sleep history of SleepHistoryViewModelTests")
        }
    }
}
