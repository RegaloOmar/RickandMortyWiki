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

    func testGetCharactersInfo() {
        let expectation = XCTestExpectation(description: "Get characters information")
        
        Task {
            do {
                let charactersInfo = try await rickAndMortyService.getCharactersInfo()
                XCTAssertNotNil(charactersInfo)
            } catch {
                XCTFail("Error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

    func testLoadMore() {
        let expectation = XCTestExpectation(description: "Load more characters")
        
        Task {
            do {
                let url = "https://rickandmortyapi.com/api/character/?page=2"
                let charactersInfo = try await rickAndMortyService.loadMore(url: url)
                XCTAssertNotNil(charactersInfo)
            } catch {
                XCTFail("Error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

    func testGetCharactersWithFilters() {
        let expectation = XCTestExpectation(description: "Get characters with filters")
        let statusArray = ["alive", "all", "dead", "unkown"]
        Task {
            do {
                let status = statusArray.randomElement()
                let charactersInfo = try await rickAndMortyService.getCharactersWithFilters(status: status!)
                XCTAssertNotNil(charactersInfo)
            } catch {
                XCTFail("Error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchEpisodes() {
        let expectation = XCTestExpectation(description: "Fetch episodes")
        
        Task {
            do {
                let episodeURLs = [
                    "https://rickandmortyapi.com/api/episode/1",
                    "https://rickandmortyapi.com/api/episode/10",
                    "https://rickandmortyapi.com/api/episode/21",
                    "https://rickandmortyapi.com/api/episode/31",
                    "https://rickandmortyapi.com/api/episode/41",
                    "https://rickandmortyapi.com/api/episode/51"
                ]
                let episodes = try await rickAndMortyService.fetchEpisodes(from: episodeURLs)
                XCTAssertFalse(episodes.isEmpty)
            } catch {
                XCTFail("Error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
