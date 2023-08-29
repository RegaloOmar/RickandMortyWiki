//
//  CharacterDetailViewModel.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 28/08/23.
//

import Foundation

class CharacterDetailViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var error: Error?
    
    private let characterDetailService: RickandMortyServiceProtocol
    private var mainQueue = DispatchQueue.main
    
    
    init(characterDetailService: RickandMortyServiceProtocol = RickAndMortyService()) {
        self.characterDetailService = characterDetailService
    }
    
    func fetchEpisodes(characterEpisodes: [String]) async {
        do {
            let episodesInfo = try await characterDetailService.fetchEpisodes(from: characterEpisodes)
            mainQueue.async { [weak self] in
                self?.episodes = episodesInfo
            }
        } catch {
            mainQueue.async { [weak self] in
                self?.error = error
            }
        }
    }
}
