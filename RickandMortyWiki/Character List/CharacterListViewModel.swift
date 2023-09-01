import Foundation

class CharacterListViewModel: ObservableObject {
    
    @Published var characters: [Character] = []
    @Published var error: Error?
    
    private let characterService: RickandMortyServiceProtocol
    private var nextPage: String?
    private var mainQueue = DispatchQueue.main
    //To trigger error change to true
    private var shouldSimulateError = false
    
    init(characterService: RickandMortyServiceProtocol = RickAndMortyService()) {
        self.characterService = characterService
    }
    
    func fetchCharactersData() async {
        do {
            if shouldSimulateError {
                throw NSError(domain: "com.ram.error",
                              code: 1,
                              userInfo: [NSLocalizedDescriptionKey: "Simulated error"])
            }
            
            let rootInfo = try await characterService.getCharactersInfo()
            mainQueue.async { [weak self] in
                self?.characters = rootInfo.results
                self?.nextPage = rootInfo.info.next
            }
        } catch {
            mainQueue.async { [weak self] in
                self?.error = error
            }
        }
    }
    
    func loadMore() async {
        guard
            let nextPage = nextPage,
            !nextPage.isEmpty
        else {
            return
        }
        
        do {
            let rootInfo = try await characterService.loadMore(url: nextPage)
            mainQueue.async { [weak self] in
                self?.characters.append(contentsOf: rootInfo.results)
                self?.nextPage = rootInfo.info.next
            }
        } catch {
            mainQueue.async { [weak self] in
                self?.error = error
            }
        }
    }
    
    func getCharactersWithStatus(_ status: String) async {
        do {
            let rootInfo = try await characterService.getCharactersWithFilters(status: status)
            mainQueue.async { [weak self] in
                self?.characters = rootInfo.results
                self?.nextPage = rootInfo.info.next
            }
        } catch {
            mainQueue.async { [weak self] in
                self?.error = error
            }
        }
    }
}
