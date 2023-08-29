//
//  RickAndMortyServiceTests.swift
//  RickandMortyWikiTests
//
//  Created by Omar Regalado on 28/08/23.
//

import XCTest
@testable import RickandMortyWiki

class RickAndMortyServiceTests: XCTestCase {
 
    var rickAndMortyService: RickAndMortyService!
    
    override func setUp() {
        super.setUp()
        rickAndMortyService = RickAndMortyService()
    }
    
    override func tearDown() {
        rickAndMortyService = nil
        super.tearDown()
    }
    
    // Test getCharactersInfo() method
    func testGetCharactersInfo() async throws {
        let charactersInfo = try await rickAndMortyService.getCharactersInfo()
        XCTAssertNotNil(charactersInfo)
    }
    
    // Test loadMore(url:) method
    func testLoadMore() async throws {
        let url = "https://rickandmortyapi.com/api/character/?page=2"
        let nextPage = try await rickAndMortyService.loadMore(url: url)
        XCTAssertNotNil(nextPage)
    }
    
    // Test getCharactersWithFilters(status:) method with alive status
    func testGetCharactersWithFilters() async throws {
        let status = "alive"
        let charactersInfo = try await rickAndMortyService.getCharactersWithFilters(status: status)
        XCTAssertNotNil(charactersInfo)
    }
    
    // Test fetchEpisodes(from:) method
    func testFetchEpisodes() async throws {
        let episodeURLs = [
            "https://rickandmortyapi.com/api/episode/10",
            "https://rickandmortyapi.com/api/episode/28",
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/50"
        ]
        let episodes = try await rickAndMortyService.fetchEpisodes(from: episodeURLs)
        XCTAssertNotNil(episodes)
        XCTAssertEqual(episodes.count, episodeURLs.count)
    }
}

