//
//  CharacterListViewModel.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 24/08/23.
//

import Foundation
import SwiftUI

class CharacterListViewModel: ObservableObject {
    
    @Published var characters: [Character] = []
    private let characterService: RickandMortyServiceProtocol
    var nextPage: String?
    var prevPage: String?
    
    init(characterService: RickandMortyServiceProtocol = RickAndMortyService()) {
        self.characterService = characterService
    }
    
    func fetchCharactersData() async {
        do {
            let rootInfo = try await characterService.getCharactersInfo()
            DispatchQueue.main.async {
                self.characters = rootInfo.results
                self.nextPage = rootInfo.info.next
                self.prevPage = rootInfo.info.prev
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func isNextPageAvailable() -> Bool {
        nextPage != nil ? true : false
    }
   

}
