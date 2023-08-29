//
//  CharacterListViewModelTests.swift
//  RickandMortyWikiTests
//
//  Created by Omar Regalado on 28/08/23.
//

import XCTest

@testable import RickandMortyWiki

class CharacterListViewModelTests: XCTestCase {

    var viewModel: CharacterListViewModel!

    override func setUpWithError() throws {
        viewModel = CharacterListViewModel(characterService: MockRickAndMortyService())
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFetchCharactersData() async {
        do {
            try await viewModel.fetchCharactersData()
            XCTAssertTrue(viewModel.characters.count > 0, "Characters should be fetched")
        } catch {
            XCTFail("Error occurred: \(error.localizedDescription)")
        }
    }

    func testLoadMore() async throws {
        // You might need to set up the viewModel with initial data for this test
        try await viewModel.loadMore()
        XCTAssertTrue(viewModel.characters.count > 0, "Characters should be loaded")
    }

    func testGetCharactersWithStatus() async throws {
        let status = "alive"
        try await viewModel.getCharactersWithStatus(status)
        XCTAssertTrue(viewModel.characters.count > 0, "Characters with status should be fetched")
    }
}

// Mock RickAndMortyService for testing purposes
class MockRickAndMortyService: RickandMortyServiceProtocol {
    
    func fetchEpisodes(from characterEpisodesURL: [String]) async throws -> [Episode] {
        
    }
    
    func getCharactersInfo() async throws -> Root {
        // Return mocked RootInfo for testing fetchCharactersData
        // Make sure to provide appropriate mocked data
    }

    func loadMore(url: String) async throws -> Root {
        // Return mocked RootInfo for testing loadMore
        // Make sure to provide appropriate mocked data
    }

    func getCharactersWithFilters(status: String) async throws -> Root {
        // Return mocked RootInfo for testing getCharactersWithStatus
        // Make sure to provide appropriate mocked data
    }
}

