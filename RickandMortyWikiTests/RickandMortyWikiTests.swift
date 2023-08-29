//
//  RickandMortyWikiTests.swift
//  RickandMortyWikiTests
//
//  Created by Omar Regalado on 24/08/23.
//

import XCTest
@testable import RickandMortyWiki

class CharacterListViewModelTests: XCTestCase {
    
    var viewModel: CharacterListViewModel!
    
    override func setUp() {
        super.setUp()
        // Initialize the view model with a mock service or actual service (if needed)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Test fetchCharactersData()
    
    func testFetchCharactersData() async throws {
        // Set up expectations if needed
        // Call the fetchCharactersData() method
        try await viewModel.fetchCharactersData()
        // Assert the results using XCTAssertEqual or similar methods
        XCTAssertFalse(viewModel.characters.isEmpty)
    }
    
    // MARK: - Test loadMore()
    
    func testLoadMore() async throws {
        // Set up expectations if needed
        // Call the loadMore() method
        try await viewModel.loadMore()
        // Assert the results using XCTAssertEqual or similar methods
        // For example, you can check if the characters count increased
        XCTAssertTrue(viewModel.characters.count > 0)
    }
    
    // MARK: - Test getCharactersWithStatus(_:)
    
    func testGetCharactersWithStatus() async throws {
        // Set up expectations if needed
        let status = "alive" // Set the status value
        // Call the getCharactersWithStatus(_:) method
        try await viewModel.getCharactersWithStatus(status)
        // Assert the results using XCTAssertEqual or similar methods
        XCTAssertFalse(viewModel.characters.isEmpty)
    }
    
    // Add more test cases as needed
    
}
