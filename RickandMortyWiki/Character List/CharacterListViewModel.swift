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
    private var nextPage: String?
    
    init(characterService: RickandMortyServiceProtocol = RickAndMortyService()) {
        self.characterService = characterService
    }
    
    func fetchCharactersData() async {
        do {
            let rootInfo = try await characterService.getCharactersInfo()
            DispatchQueue.main.async {
                self.characters = rootInfo.results
                self.nextPage = rootInfo.info.next
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func isNextPageAvailable() -> Bool {
        nextPage != nil ? true : false
    }
    
    func loadMore() async {
        guard
            let isNextPageEnable = nextPage?.isEmpty,
                isNextPageEnable != true,
                let nextPage = nextPage else {
            return
        }
        
        do {
            let rootInfo = try await characterService.loadMore(url: nextPage)
            DispatchQueue.main.async {
                self.characters.append(contentsOf: rootInfo.results)
                self.nextPage = rootInfo.info.next
            }
        }catch {
            print(error.localizedDescription)
        }
    }

}
